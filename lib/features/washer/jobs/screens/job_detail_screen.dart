import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/core/widgets/app_avatar.dart';
import 'package:clean_ride/features/washer/jobs/widgets/job_action_buttons.dart';
import 'package:gap/gap.dart';

class JobDetailScreen extends StatelessWidget {
  final String jobId;

  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  // Mock data based on jobId
  Map<String, dynamic> get _jobData => {
        'status': 'confirmed',
        'customerName': 'Sarah Chen',
        'customerPhone': '+1 555-0102',
        'vehicleMake': 'BMW',
        'vehicleModel': 'X5',
        'vehicleColor': 'Black',
        'vehiclePlate': 'CA 7XYZ890',
        'serviceName': 'Premium Detail',
        'addOns': ['Interior Deep Clean', 'Tire Shine'],
        'duration': '2 hours',
        'address': '789 Elm Boulevard, Unit 7, Los Angeles, CA 90001',
        'scheduledDate': 'Today, Feb 18',
        'timeSlot': '1:00 PM - 3:00 PM',
        'totalAmount': 2100000.0,
        'notes': 'White BMW in the driveway. Gate code is 4521.',
        'bookingId': 'BK-1003',
      };

  Color get _statusBannerColor {
    switch (_jobData['status']) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return AppColors.primary;
      case 'washerEnRoute':
        return AppColors.primary;
      case 'inProgress':
        return AppColors.success;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String get _statusLabel {
    switch (_jobData['status']) {
      case 'pending':
        return 'Pending Acceptance';
      case 'confirmed':
        return 'Confirmed';
      case 'washerEnRoute':
        return 'En Route';
      case 'inProgress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return _jobData['status'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Job #${_jobData['bookingId']}',
          style: AppTypography.titleLarge,
        ),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                      horizontal: AppSpacing.lg,
                    ),
                    color: _statusBannerColor,
                    child: Row(
                      children: [
                        Icon(
                          _statusIcon,
                          color: Colors.white,
                          size: 18,
                        ),
                        const Gap(AppSpacing.sm),
                        Text(
                          _statusLabel,
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Info Card
                        _buildSectionCard(
                          title: 'Customer',
                          child: Row(
                            children: [
                              AppAvatar(
                                name: _jobData['customerName'],
                                size: 48,
                              ),
                              const Gap(AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _jobData['customerName'],
                                      style: AppTypography.titleMedium,
                                    ),
                                    const Gap(2),
                                    Text(
                                      _jobData['customerPhone'],
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.phone,
                                  color: AppColors.primary,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(AppSpacing.lg),

                        // Vehicle Info Card
                        _buildSectionCard(
                          title: 'Vehicle',
                          child: Column(
                            children: [
                              _buildInfoRow(
                                Icons.directions_car,
                                'Make / Model',
                                '${_jobData['vehicleMake']} ${_jobData['vehicleModel']}',
                              ),
                              const Gap(AppSpacing.md),
                              _buildInfoRow(
                                Icons.color_lens_outlined,
                                'Color',
                                _jobData['vehicleColor'],
                              ),
                              const Gap(AppSpacing.md),
                              _buildInfoRow(
                                Icons.badge_outlined,
                                'Plate',
                                _jobData['vehiclePlate'],
                              ),
                            ],
                          ),
                        ),
                        const Gap(AppSpacing.lg),

                        // Service Details Card
                        _buildSectionCard(
                          title: 'Service Details',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                Icons.local_car_wash,
                                'Package',
                                _jobData['serviceName'],
                              ),
                              const Gap(AppSpacing.md),
                              _buildInfoRow(
                                Icons.access_time,
                                'Duration',
                                _jobData['duration'],
                              ),
                              const Gap(AppSpacing.md),
                              _buildInfoRow(
                                Icons.calendar_today,
                                'Date',
                                _jobData['scheduledDate'],
                              ),
                              const Gap(AppSpacing.md),
                              _buildInfoRow(
                                Icons.schedule,
                                'Time',
                                _jobData['timeSlot'],
                              ),
                              if ((_jobData['addOns'] as List).isNotEmpty) ...[
                                const Gap(AppSpacing.md),
                                const Divider(color: AppColors.divider),
                                const Gap(AppSpacing.sm),
                                Text(
                                  'Add-ons',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const Gap(AppSpacing.sm),
                                Wrap(
                                  spacing: AppSpacing.sm,
                                  runSpacing: AppSpacing.sm,
                                  children:
                                      (_jobData['addOns'] as List<String>)
                                          .map((addon) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: AppSpacing.md,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryLight,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  addon,
                                                  style: AppTypography
                                                      .labelSmall
                                                      .copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Gap(AppSpacing.lg),

                        // Address Card with Map Placeholder
                        _buildSectionCard(
                          title: 'Location',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusSm),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.map,
                                    size: 48,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const Gap(AppSpacing.md),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const Gap(AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      _jobData['address'],
                                      style: AppTypography.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(AppSpacing.lg),

                        // Special Instructions
                        if (_jobData['notes'] != null &&
                            (_jobData['notes'] as String).isNotEmpty)
                          _buildSectionCard(
                            title: 'Special Instructions',
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                const Gap(AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    _jobData['notes'],
                                    style: AppTypography.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Price
                        const Gap(AppSpacing.lg),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: AppTypography.titleMedium,
                              ),
                              Text(
                                'Rp ${NumberFormat('#,###').format((_jobData['totalAmount'] as double).toInt())}',
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(AppSpacing.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: JobActionButtons(
                status: _jobData['status'],
                onAccept: () {},
                onDecline: () {},
                onNavigate: () {},
                onStartWash: () {},
                onMarkComplete: () {},
                onViewDetails: () {},
                onViewReview: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData get _statusIcon {
    switch (_jobData['status']) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'washerEnRoute':
        return Icons.directions_car;
      case 'inProgress':
        return Icons.local_car_wash;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Gap(AppSpacing.md),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const Gap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
