import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/models/booking.dart';
import 'package:clean_ride/data/providers/washer_jobs_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gap/gap.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _morningAvailable = true;
  bool _afternoonAvailable = true;
  bool _eveningAvailable = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Booking> _jobsForDay(List<Booking> jobs, DateTime day) {
    return jobs.where((j) => isSameDay(j.scheduledDate, day)).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(washerJobsProvider);
    final selectedDay = _selectedDay ?? _focusedDay;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Schedule', style: AppTypography.titleLarge),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.surface,
              child: TableCalendar(
                firstDay: DateTime.now().subtract(const Duration(days: 90)),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() => _calendarFormat = format);
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  selectedTextStyle: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                  defaultTextStyle: AppTypography.bodyMedium,
                  weekendTextStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  outsideTextStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.divider,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: AppTypography.titleMedium,
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: AppColors.textPrimary,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textPrimary,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  weekendStyle: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Availability', style: AppTypography.titleMedium),
                  const Gap(AppSpacing.sm),
                  Container(
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
                      children: [
                        SwitchListTile(
                          title: Text('Morning', style: AppTypography.bodyLarge),
                          subtitle: Text(
                            '8:00 AM - 12:00 PM',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          secondary: Icon(
                            Icons.wb_sunny_outlined,
                            color: _morningAvailable
                                ? AppColors.warning
                                : AppColors.textSecondary,
                          ),
                          value: _morningAvailable,
                          activeThumbColor: AppColors.primary,
                          onChanged: (value) =>
                              setState(() => _morningAvailable = value),
                        ),
                        const Divider(
                          height: 1,
                          color: AppColors.divider,
                          indent: AppSpacing.lg,
                          endIndent: AppSpacing.lg,
                        ),
                        SwitchListTile(
                          title: Text('Afternoon', style: AppTypography.bodyLarge),
                          subtitle: Text(
                            '12:00 PM - 5:00 PM',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          secondary: Icon(
                            Icons.wb_cloudy_outlined,
                            color: _afternoonAvailable
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          value: _afternoonAvailable,
                          activeThumbColor: AppColors.primary,
                          onChanged: (value) =>
                              setState(() => _afternoonAvailable = value),
                        ),
                        const Divider(
                          height: 1,
                          color: AppColors.divider,
                          indent: AppSpacing.lg,
                          endIndent: AppSpacing.lg,
                        ),
                        SwitchListTile(
                          title: Text('Evening', style: AppTypography.bodyLarge),
                          subtitle: Text(
                            '5:00 PM - 9:00 PM',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          secondary: Icon(
                            Icons.nightlight_outlined,
                            color: _eveningAvailable
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                          ),
                          value: _eveningAvailable,
                          activeThumbColor: AppColors.primary,
                          onChanged: (value) =>
                              setState(() => _eveningAvailable = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.xl),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Scheduled Jobs', style: AppTypography.titleMedium),
                  const Gap(AppSpacing.md),
                  jobsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => Center(
                      child: Text(
                        'Could not load jobs',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    data: (jobs) {
                      final dayJobs = _jobsForDay(jobs, selectedDay);
                      if (dayJobs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.event_available_outlined,
                                  size: 48,
                                  color: AppColors.textSecondary,
                                ),
                                const Gap(12),
                                Text(
                                  'No jobs scheduled',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: dayJobs.map((job) {
                          final timeStr =
                              '${job.scheduledDate.hour.toString().padLeft(2, '0')}:${job.scheduledDate.minute.toString().padLeft(2, '0')}';
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.md),
                            child: GestureDetector(
                              onTap: () =>
                                  context.push('/washer/jobs/${job.id}'),
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMd),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0A000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: _statusColor(job.status),
                                        borderRadius:
                                            BorderRadius.circular(2),
                                      ),
                                    ),
                                    const Gap(AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job.vehicleId,
                                            style: AppTypography.titleMedium,
                                          ),
                                          const Gap(2),
                                          Text(
                                            job.address,
                                            style: AppTypography.bodyMedium
                                                .copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Gap(AppSpacing.md),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        timeStr,
                                        style:
                                            AppTypography.labelSmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.inProgress:
        return AppColors.warning;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
