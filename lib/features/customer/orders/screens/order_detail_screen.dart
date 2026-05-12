import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_status_indicator.dart';
import 'package:clean_ride/data/providers/orders_provider.dart';
import 'package:clean_ride/data/providers/payment_provider.dart';
import 'package:gap/gap.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const OrderDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  String? _invoiceUrl;
  bool _preparingInvoice = false;
  Timer? _pollTimer;
  bool _everPolled = false;

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _ensurePolling(bool shouldPoll) {
    if (shouldPoll && _pollTimer == null) {
      _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;
        _everPolled = true;
        ref.invalidate(orderDetailProvider(widget.bookingId));
      });
    } else if (!shouldPoll && _pollTimer != null) {
      _pollTimer?.cancel();
      _pollTimer = null;
    }
  }

  Future<void> _prepareInvoice(String? existingUrl) async {
    if (_preparingInvoice || _invoiceUrl != null) return;

    if (existingUrl != null) {
      if (mounted) setState(() => _invoiceUrl = existingUrl);
      return;
    }

    setState(() => _preparingInvoice = true);
    try {
      final url = await ref
          .read(paymentNotifierProvider(widget.bookingId).notifier)
          .createInvoice(widget.bookingId);
      if (mounted) setState(() => _invoiceUrl = url);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _preparingInvoice = false);
    }
  }

  void _launchPayment() async {
    final url = _invoiceUrl;
    if (url == null) return;

    try {
      final uri = Uri.parse(url);
      // On web: webOnlyWindowName '_self' navigates the CURRENT tab, bypassing
      //   popup blockers entirely. Session is restored on return via main().
      // On mobile: LaunchMode.externalApplication opens system browser.
      final ok = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_self',
      );
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              'Browser blocked the payment window. Copy the link instead.'),
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: 'Copy link',
            textColor: Colors.white,
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: url)),
          ),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not open payment page: $e'),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  void _refresh() {
    setState(() {
      _invoiceUrl = null;
      _preparingInvoice = false;
    });
    ref.invalidate(orderDetailProvider(widget.bookingId));
    ref.invalidate(paymentStatusProvider(widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(orderDetailProvider(widget.bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
            'Order #${widget.bookingId.length > 8 ? widget.bookingId.substring(0, 8).toUpperCase() : widget.bookingId.toUpperCase()}'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refresh,
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load order', style: AppTypography.titleMedium),
            const Gap(16),
            TextButton(
              onPressed: () =>
                  ref.invalidate(orderDetailProvider(widget.bookingId)),
              child: const Text('Retry'),
            ),
          ]),
        ),
        data: (data) {
          if (data == null) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_outlined,
                        size: 48, color: AppColors.textSecondary),
                    const Gap(12),
                    Text('Order not found', style: AppTypography.titleMedium),
                  ]),
            );
          }

          final order = data['order'] as Map<String, dynamic>;
          final history = data['history'] as List? ?? [];
          final status = order['status']?.toString() ?? 'pending';
          final isDone = status == 'done';
          final scheduledAt = order['scheduled_at'] != null
              ? DateTime.parse(order['scheduled_at'].toString())
              : null;
          final appStatus = _mapStatus(status);
          final amount = ((order['total_amount'] as num?) ?? 0).toInt();

          final paymentStatus = order['payment_status']?.toString();
          final dbInvoiceUrl = order['xendit_invoice_url']?.toString();
          final isPaid = paymentStatus == 'paid';

          // Washer info from JOIN
          final washerName = order['washer_name']?.toString();
          final washerPhone = order['washer_phone']?.toString();
          final washerAvatar = order['washer_avatar']?.toString();

          // Eagerly prepare invoice for unpaid completed orders
          if (isDone && !isPaid && _invoiceUrl == null && !_preparingInvoice) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _prepareInvoice(dbInvoiceUrl));
          }

          // Poll for payment status while waiting on user to finish payment
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => _ensurePolling(isDone && !isPaid));

          // Stop polling and show a brief success message once paid
          if (isPaid && _everPolled) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _pollTimer?.cancel();
              _pollTimer = null;
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order info
                  _card([
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '#${(order['id']?.toString() ?? '').substring(0, 8).toUpperCase()}',
                              style: AppTypography.titleLarge,
                            ),
                          ),
                          AppStatusIndicator(status: appStatus),
                        ]),
                    const Gap(12),
                    if (scheduledAt != null)
                      _row(Icons.calendar_today,
                          DateFormat('MMM dd, yyyy • HH:mm')
                              .format(scheduledAt)),
                    const Gap(8),
                    _row(Icons.location_on_outlined,
                        order['location_address']?.toString() ?? 'No address'),
                    const Gap(8),
                    _row(
                        Icons.directions_car,
                        '${order['vehicle_type']?.toString().toUpperCase() ?? ''} • ${order['vehicle_plate'] ?? ''}'),
                    const Gap(8),
                    _row(Icons.payments_outlined,
                        'Rp ${NumberFormat('#,###').format(amount)}'),
                  ]),
                  const Gap(16),

                  // Washer info — Gojek-style
                  if (washerName != null) ...[
                    _WasherCard(
                      name: washerName,
                      phone: washerPhone,
                      avatar: washerAvatar,
                      status: status,
                    ),
                    const Gap(16),
                  ],

                  // Payment — only for completed orders
                  if (isDone) ...[
                    _PaymentCard(
                      paymentStatus: paymentStatus,
                      amount: amount,
                      invoiceReady: _invoiceUrl != null,
                      preparingInvoice: _preparingInvoice,
                      onPay: _launchPayment,
                      referenceId: order['xendit_invoice_id']?.toString(),
                    ),
                    const Gap(16),
                  ],

                  // Status history
                  if (history.isNotEmpty) ...[
                    _card([
                      Text('Status History',
                          style: AppTypography.titleMedium),
                      const Gap(12),
                      ...history.map((h) {
                        final hMap = h as Map<String, dynamic>;
                        final changedAt = hMap['changed_at'] != null
                            ? DateTime.parse(hMap['changed_at'].toString())
                            : null;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary),
                            ),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hMap['status']
                                              ?.toString()
                                              .replaceAll('_', ' ')
                                              .toUpperCase() ??
                                          '',
                                      style: AppTypography.labelSmall
                                          .copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    if (changedAt != null)
                                      Text(
                                          DateFormat('MMM dd, HH:mm')
                                              .format(changedAt),
                                          style: AppTypography.labelSmall
                                              .copyWith(
                                                  color: AppColors
                                                      .textSecondary)),
                                  ]),
                            ),
                          ]),
                        );
                      }),
                    ]),
                    const Gap(16),
                  ],

                  // Track
                  if (status != 'done' && status != 'cancelled')
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context
                            .push('/customer/tracking/${widget.bookingId}'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd)),
                        ),
                        child: const Text('Track Order'),
                      ),
                    ),
                ]),
          );
        },
      ),
    );
  }

  AppStatus _mapStatus(String s) {
    switch (s) {
      case 'confirmed':
        return AppStatus.confirmed;
      case 'on_the_way':
      case 'in_progress':
        return AppStatus.inProgress;
      case 'done':
        return AppStatus.completed;
      case 'cancelled':
        return AppStatus.cancelled;
      default:
        return AppStatus.pending;
    }
  }

  Widget _card(List<Widget> children) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 2))
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _row(IconData icon, String text) => Row(children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const Gap(8),
        Expanded(
            child: Text(text,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary))),
      ]);
}

// ─────────────────────────────────────────────
// Washer card — Gojek-style
// ─────────────────────────────────────────────

class _WasherCard extends StatelessWidget {
  final String name;
  final String? phone;
  final String? avatar;
  final String status;

  const _WasherCard({
    required this.name,
    required this.phone,
    required this.avatar,
    required this.status,
  });

  String _statusLabel() {
    switch (status) {
      case 'confirmed':
        return 'Your washer is preparing';
      case 'on_the_way':
        return 'On the way to you';
      case 'in_progress':
        return 'Washing your car now';
      case 'done':
        return 'Wash completed';
      default:
        return 'Assigned washer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_statusLabel(),
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.textSecondary)),
          const Gap(12),
          Row(
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage:
                      (avatar != null && avatar!.isNotEmpty)
                          ? NetworkImage(avatar!)
                          : null,
                  child: (avatar == null || avatar!.isEmpty)
                      ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: AppTypography.titleMedium
                              .copyWith(color: AppColors.primary),
                        )
                      : null,
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: AppTypography.titleMedium
                            .copyWith(fontWeight: FontWeight.w700)),
                    const Gap(2),
                    Row(children: [
                      const Icon(Icons.local_car_wash_rounded,
                          size: 13, color: AppColors.textSecondary),
                      const Gap(4),
                      Text('CleanRide Washer',
                          style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary)),
                      const Gap(8),
                      const Icon(Icons.star_rounded,
                          size: 14, color: Color(0xFFFBBF24)),
                      const Gap(2),
                      Text('4.9',
                          style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600)),
                    ]),
                  ],
                ),
              ),
              if (phone != null && phone!.isNotEmpty)
                IconButton(
                  onPressed: () =>
                      launchUrl(Uri.parse('tel:$phone')),
                  icon: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone_rounded,
                        color: AppColors.success, size: 18),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Payment card
// ─────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  final String? paymentStatus;
  final int amount;
  final bool invoiceReady;
  final bool preparingInvoice;
  final VoidCallback onPay;
  final String? referenceId;

  const _PaymentCard({
    required this.paymentStatus,
    required this.amount,
    required this.invoiceReady,
    required this.preparingInvoice,
    required this.onPay,
    required this.referenceId,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = paymentStatus == 'paid';
    if (isPaid) return _PaidCard(amount: amount, referenceId: referenceId);

    final isExpired = paymentStatus == 'expired';

    Color headerColor;
    IconData headerIcon;
    String headerTitle;
    if (isExpired) {
      headerColor = AppColors.error;
      headerIcon = Icons.cancel_rounded;
      headerTitle = 'Payment Expired';
    } else {
      headerColor = AppColors.warning;
      headerIcon = Icons.schedule_rounded;
      headerTitle = 'Payment Required';
    }

    final String buttonLabel = preparingInvoice
        ? 'Preparing payment…'
        : isExpired
            ? 'Retry Payment'
            : 'Pay Now  •  Rp ${NumberFormat('#,###').format(amount)}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: headerColor.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(children: [
            Icon(headerIcon, color: headerColor, size: 18),
            const Gap(8),
            Text(headerTitle,
                style: AppTypography.labelLarge.copyWith(
                    color: headerColor, fontWeight: FontWeight.w700)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
              Text(
                'Rp ${NumberFormat('#,###').format(amount)}',
                style: AppTypography.titleMedium
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ]),
            const Gap(6),
            Row(children: [
              const Icon(Icons.shield_rounded,
                  size: 13, color: AppColors.textSecondary),
              const Gap(4),
              Text('Secured by Xendit',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.textSecondary)),
            ]),
            const Gap(14),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    (invoiceReady && !preparingInvoice) ? onPay : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.divider,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: preparingInvoice
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textSecondary),
                          ),
                          const Gap(10),
                          Text(buttonLabel,
                              style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.textSecondary)),
                        ],
                      )
                    : Text(buttonLabel,
                        style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// Paid receipt card
// ─────────────────────────────────────────────

class _PaidCard extends StatelessWidget {
  final int amount;
  final String? referenceId;

  const _PaidCard({required this.amount, required this.referenceId});

  Future<void> _copyRef(BuildContext context) async {
    if (referenceId == null) return;
    await Clipboard.setData(ClipboardData(text: referenceId!));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Reference ID copied'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.08),
            AppColors.success.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
            color: AppColors.success.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big check + heading
            Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 24),
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Already Paid',
                      style: AppTypography.titleMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700)),
                  Text('Thank you for your payment',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ]),
            const Gap(16),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Amount Paid',
                            style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary)),
                        Text(
                          'Rp ${NumberFormat('#,###').format(amount)}',
                          style: AppTypography.titleMedium.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                  if (referenceId != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: AppColors.divider),
                    ),
                    Row(children: [
                      Text('Reference ID',
                          style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary)),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          referenceId!,
                          style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace'),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Gap(6),
                      InkWell(
                        onTap: () => _copyRef(context),
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.copy_rounded,
                              size: 14, color: AppColors.primary),
                        ),
                      ),
                    ]),
                  ],
                ],
              ),
            ),
            const Gap(12),
            Row(children: [
              const Icon(Icons.shield_rounded,
                  size: 12, color: AppColors.textSecondary),
              const Gap(4),
              Text('Payment processed by Xendit',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.textSecondary)),
            ]),
          ],
        ),
      ),
    );
  }
}
