import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/washer_jobs_provider.dart';
import 'package:gap/gap.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(washerJobsProvider);

    return jobsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Job Detail')),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const Gap(12),
            Text('Could not load job', style: AppTypography.titleMedium),
            const Gap(16),
            TextButton(
              onPressed: () => ref.invalidate(washerJobsProvider),
              child: const Text('Retry'),
            ),
          ]),
        ),
      ),
      data: (jobs) {
        Booking? job;
        try {
          job = jobs.firstWhere((j) => j.id == jobId);
        } catch (_) {
          job = null;
        }

        if (job == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Job Detail'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Job not found')),
          );
        }

        return _JobDetailView(job: job);
      },
    );
  }
}

class _JobDetailView extends ConsumerStatefulWidget {
  final Booking job;
  const _JobDetailView({required this.job});

  @override
  ConsumerState<_JobDetailView> createState() => _JobDetailViewState();
}

class _JobDetailViewState extends ConsumerState<_JobDetailView> {
  bool _isUpdating = false;

  Future<void> _updateStatus(String newStatus, {String? reason}) async {
    setState(() => _isUpdating = true);
    final error = await ref
        .read(washerJobActionsProvider)
        .updateStatus(widget.job.id, newStatus, reason: reason);
    if (!mounted) return;
    setState(() => _isUpdating = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status updated'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _onAccept() async {
    setState(() => _isUpdating = true);
    final error =
        await ref.read(washerJobActionsProvider).accept(widget.job.id);
    if (!mounted) return;
    setState(() => _isUpdating = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _onDecline() async {
    final reason = await _promptReason(
      title: 'Decline this job?',
      hint: 'Optional — let admin know why',
    );
    if (reason == null || !mounted) return; // user cancelled the dialog
    setState(() => _isUpdating = true);
    final error = await ref
        .read(washerJobActionsProvider)
        .decline(widget.job.id, reason: reason.isEmpty ? null : reason);
    if (!mounted) return;
    setState(() => _isUpdating = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _reportProblem(String status) async {
    final isNoShow = status == 'no_show';
    final reason = await _promptReason(
      title: isNoShow ? 'Customer not home?' : 'What went wrong?',
      hint: isNoShow
          ? 'Optional notes'
          : 'Required — describe the problem',
      requireReason: !isNoShow,
    );
    if (reason == null) return;
    await _updateStatus(status, reason: reason.isEmpty ? null : reason);
  }

  Future<String?> _promptReason({
    required String title,
    required String hint,
    bool requireReason = false,
  }) async {
    final ctrl = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (requireReason && ctrl.text.trim().isEmpty) return;
              Navigator.of(ctx).pop(ctrl.text.trim());
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openMaps(String address) async {
    final encoded = Uri.encodeComponent(address);
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Color get _statusColor {
    switch (widget.job.status) {
      case BookingStatus.assigned:
        return AppColors.warning;
      case BookingStatus.confirmed:
        return AppColors.primary;
      case BookingStatus.washerEnRoute:
        return AppColors.warning;
      case BookingStatus.inProgress:
        return AppColors.success;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
      case BookingStatus.noShow:
      case BookingStatus.failed:
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  String get _statusLabel {
    switch (widget.job.status) {
      case BookingStatus.assigned:
        return 'Accept or decline this job';
      case BookingStatus.confirmed:
        return 'Ready to start';
      case BookingStatus.washerEnRoute:
        return 'En route to customer';
      case BookingStatus.inProgress:
        return 'Washing in progress';
      case BookingStatus.completed:
        return 'Job complete';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.noShow:
        return 'Customer no-show';
      case BookingStatus.failed:
        return 'Could not complete';
      default:
        return 'Pending';
    }
  }

  IconData get _statusIcon {
    switch (widget.job.status) {
      case BookingStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case BookingStatus.washerEnRoute:
        return Icons.directions_car_rounded;
      case BookingStatus.inProgress:
        return Icons.local_car_wash_rounded;
      case BookingStatus.completed:
        return Icons.task_alt_rounded;
      case BookingStatus.cancelled:
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('#${job.shortId}', style: AppTypography.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md, horizontal: AppSpacing.lg),
            color: _statusColor,
            child: Row(
              children: [
                Icon(_statusIcon, color: Colors.white, size: 20),
                const Gap(AppSpacing.sm),
                Text(_statusLabel,
                    style: AppTypography.labelLarge
                        .copyWith(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Customer card ─────────────────────────────
                  _CustomerCard(
                    name: job.customerName,
                    phone: job.customerPhone,
                    avatar: job.customerAvatar,
                    onCall: () {
                      if (job.customerPhone != null &&
                          job.customerPhone!.isNotEmpty) {
                        _call(job.customerPhone!);
                      }
                    },
                  ),
                  const Gap(AppSpacing.lg),

                  // ─── Plate validation card ─────────────────────
                  _PlateValidationCard(
                    plate: job.vehicleId.toUpperCase(),
                    serviceName: job.serviceName,
                  ),
                  const Gap(AppSpacing.lg),

                  // ─── Address card with tap-to-navigate ─────────
                  _card('Customer Address', [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.location_on_rounded,
                              color: AppColors.primary, size: 20),
                        ),
                        const Gap(AppSpacing.md),
                        Expanded(
                          child: Text(job.address,
                              style: AppTypography.bodyMedium),
                        ),
                      ],
                    ),
                    if (job.address.isNotEmpty) ...[
                      const Gap(AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _openMaps(job.address),
                          icon: const Icon(Icons.map_rounded, size: 18),
                          label: const Text('Open in Maps'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ]),
                  const Gap(AppSpacing.lg),

                  // ─── Schedule ──────────────────────────────────
                  _card('Schedule', [
                    Row(children: [
                      _scheduleChip(
                        Icons.calendar_today_rounded,
                        DateFormat('EEE, MMM dd').format(job.scheduledDate),
                      ),
                      const Gap(AppSpacing.sm),
                      _scheduleChip(
                        Icons.access_time_rounded,
                        DateFormat('HH:mm').format(job.scheduledDate),
                      ),
                    ]),
                  ]),

                  // ─── Special instructions ──────────────────────
                  if (job.notes != null && job.notes!.isNotEmpty) ...[
                    const Gap(AppSpacing.lg),
                    _card('Special Instructions', [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  AppColors.warning.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: AppColors.warning, size: 18),
                            const Gap(AppSpacing.sm),
                            Expanded(
                              child: Text(job.notes!,
                                  style: AppTypography.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                  const Gap(AppSpacing.xl),
                ],
              ),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (_isUpdating) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        color: Colors.white,
        child: const SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    Widget? content;
    switch (widget.job.status) {
      case BookingStatus.assigned:
        // Accept / Decline gate before the washer commits to the job
        content = Column(children: [
          _actionButton(
            label: 'Accept Job',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            onPressed: _onAccept,
          ),
          const Gap(10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: _onDecline,
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text('Decline'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ]);
        break;
      case BookingStatus.confirmed:
        content = _actionButton(
          label: 'Start Driving',
          icon: Icons.directions_car_rounded,
          color: AppColors.primary,
          onPressed: () => _updateStatus('on_the_way'),
        );
        break;
      case BookingStatus.washerEnRoute:
        content = Column(children: [
          _actionButton(
            label: 'I\'ve Arrived — Start Wash',
            icon: Icons.local_car_wash_rounded,
            color: AppColors.success,
            onPressed: () => _updateStatus('in_progress'),
          ),
          const Gap(8),
          TextButton.icon(
            onPressed: () => _reportProblem('no_show'),
            icon: const Icon(Icons.person_off_rounded,
                size: 16, color: AppColors.textSecondary),
            label: Text('Customer not home',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.textSecondary)),
          ),
        ]);
        break;
      case BookingStatus.inProgress:
        content = Column(children: [
          _actionButton(
            label: 'Mark Complete',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            onPressed: () => _updateStatus('done'),
          ),
          const Gap(8),
          TextButton.icon(
            onPressed: () => _reportProblem('failed'),
            icon: const Icon(Icons.report_problem_outlined,
                size: 16, color: AppColors.textSecondary),
            label: Text('Couldn\'t complete',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.textSecondary)),
          ),
        ]);
        break;
      default:
        content = null;
    }

    if (content == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(child: content),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label,
            style: AppTypography.labelLarge
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _card(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.textSecondary)),
          const Gap(AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _scheduleChip(IconData icon, String text) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const Gap(6),
          Text(text,
              style: AppTypography.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600)),
        ]),
      );
}

// ─────────────────────────────────────────────
// Customer card — like Uber driver sees rider
// ─────────────────────────────────────────────

class _CustomerCard extends StatelessWidget {
  final String? name;
  final String? phone;
  final String? avatar;
  final VoidCallback onCall;

  const _CustomerCard({
    required this.name,
    required this.phone,
    required this.avatar,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.person_rounded,
                color: Colors.white.withValues(alpha: 0.8), size: 14),
            const Gap(6),
            Text('YOUR CUSTOMER',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                )),
          ]),
          const Gap(14),
          Row(children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                backgroundImage: (avatar != null && avatar!.isNotEmpty)
                    ? NetworkImage(avatar!)
                    : null,
                child: (avatar == null || avatar!.isEmpty)
                    ? Text(
                        (name ?? '?').isNotEmpty
                            ? (name ?? '?')[0].toUpperCase()
                            : '?',
                        style: AppTypography.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      )
                    : null,
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name ?? 'Customer',
                      style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17)),
                  if (phone != null && phone!.isNotEmpty) ...[
                    const Gap(2),
                    Row(children: [
                      Icon(Icons.phone_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 13),
                      const Gap(4),
                      Text(phone!,
                          style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.85))),
                    ]),
                  ],
                ],
              ),
            ),
            if (phone != null && phone!.isNotEmpty)
              IconButton(
                onPressed: onCall,
                icon: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: const Icon(Icons.phone_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Plate validation card — for matching on arrival
// ─────────────────────────────────────────────

class _PlateValidationCard extends StatelessWidget {
  final String plate;
  final String? serviceName;

  const _PlateValidationCard({required this.plate, required this.serviceName});

  Future<void> _copyPlate(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: plate));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Plate copied'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.verified_rounded,
                color: AppColors.warning, size: 14),
            const Gap(6),
            Text('VERIFY ON ARRIVAL',
                style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1)),
          ]),
          const Gap(12),
          // Big plate display
          GestureDetector(
            onTap: () => _copyPlate(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFFBBF24), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    plate,
                    style: AppTypography.headlineLarge.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                  const Gap(10),
                  const Icon(Icons.copy_rounded,
                      size: 16, color: Color(0xFF92400E)),
                ],
              ),
            ),
          ),
          const Gap(8),
          if (serviceName != null && serviceName!.isNotEmpty)
            Row(children: [
              const Icon(Icons.local_car_wash_rounded,
                  size: 14, color: AppColors.textSecondary),
              const Gap(6),
              Text(serviceName!,
                  style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
            ]),
        ],
      ),
    );
  }
}
