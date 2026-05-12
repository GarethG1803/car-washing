import 'package:flutter/material.dart';
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
  // Cached invoice URL — loaded eagerly when order is done+unpaid so the
  // button tap has NO async gap (prevents browser popup blocker on web).
  String? _invoiceUrl;
  bool _preparingInvoice = false;

  /// Pre-fetches or creates the Xendit invoice in the background.
  /// Must be called as a fire-and-forget from the build phase.
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
      // Ignore — user can still tap Pay and we'll retry
    } finally {
      if (mounted) setState(() => _preparingInvoice = false);
    }
  }

  /// Launches payment. Always called directly from a button tap so
  /// there is zero async gap — popup blockers never fire.
  void _launchPayment() {
    final url = _invoiceUrl;
    if (url == null) return;

    final uri = Uri.parse(url);
    // platformDefault: navigates the current tab on web (no popup to block),
    // opens in-app browser on mobile.
    launchUrl(uri, mode: LaunchMode.platformDefault).catchError((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not open payment page. Try again.'),
          backgroundColor: AppColors.error,
        ));
      }
    });
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
              onPressed: () => ref.invalidate(orderDetailProvider(widget.bookingId)),
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
          final amount =
              ((order['total_amount'] as num?) ?? 0).toInt();

          // Payment state from order row
          final paymentStatus = order['payment_status']?.toString();
          final dbInvoiceUrl = order['xendit_invoice_url']?.toString();

          // Eagerly prepare invoice when order is done and not yet paid.
          // We use addPostFrameCallback to avoid calling setState during build.
          if (isDone &&
              paymentStatus != 'paid' &&
              _invoiceUrl == null &&
              !_preparingInvoice) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => _prepareInvoice(dbInvoiceUrl));
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

                  // Washer
                  if (order['assigned_employee_id'] != null) ...[
                    _card([
                      Text('Assigned Washer',
                          style: AppTypography.titleMedium),
                      const Gap(8),
                      Row(children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primaryLight,
                          child:
                              Icon(Icons.person, color: AppColors.primary),
                        ),
                        const Gap(12),
                        Text('Washer assigned',
                            style: AppTypography.bodyMedium),
                      ]),
                    ]),
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
                        onPressed: () => context.push(
                            '/customer/tracking/${widget.bookingId}'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
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
// Payment card
// ─────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  final String? paymentStatus;
  final int amount;
  final bool invoiceReady;
  final bool preparingInvoice;
  final VoidCallback onPay;

  const _PaymentCard({
    required this.paymentStatus,
    required this.amount,
    required this.invoiceReady,
    required this.preparingInvoice,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = paymentStatus == 'paid';
    final isExpired = paymentStatus == 'expired';

    Color headerColor;
    IconData headerIcon;
    String headerTitle;

    if (isPaid) {
      headerColor = AppColors.success;
      headerIcon = Icons.check_circle_rounded;
      headerTitle = 'Paid';
    } else if (isExpired) {
      headerColor = AppColors.error;
      headerIcon = Icons.cancel_rounded;
      headerTitle = 'Payment Expired';
    } else {
      headerColor = AppColors.warning;
      headerIcon = Icons.schedule_rounded;
      headerTitle = 'Payment Required';
    }

    String buttonLabel;
    if (preparingInvoice) {
      buttonLabel = 'Preparing payment…';
    } else if (isExpired) {
      buttonLabel = 'Retry Payment';
    } else {
      buttonLabel = 'Pay Now  →  Rp ${NumberFormat('#,###').format(amount)}';
    }

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
        // Header band
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
            // Amount row
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

            if (isPaid) ...[
              const Gap(12),
              Row(children: [
                const Icon(Icons.verified_rounded,
                    color: AppColors.success, size: 16),
                const Gap(6),
                Text('Payment received. Thank you!',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.success)),
              ]),
            ],

            if (!isPaid) ...[
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
                  // Enabled only when invoice URL is ready — click is then
                  // synchronous, so popup blockers cannot fire on web.
                  onPressed:
                      (invoiceReady && !preparingInvoice) ? onPay : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.divider,
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
                          style: AppTypography.labelLarge
                              .copyWith(color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ]),
        ),
      ]),
    );
  }
}
