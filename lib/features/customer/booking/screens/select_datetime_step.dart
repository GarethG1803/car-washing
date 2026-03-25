import 'package:flutter/material.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/features/customer/booking/widgets/time_slot_picker.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class SelectDatetimeStep extends StatefulWidget {
  const SelectDatetimeStep({super.key});

  @override
  State<SelectDatetimeStep> createState() => _SelectDatetimeStepState();
}

class _SelectDatetimeStepState extends State<SelectDatetimeStep> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00 AM';

  List<DateTime> get _availableDates {
    return List.generate(14, (i) => DateTime.now().add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Date & Time', style: AppTypography.titleLarge),
          const Gap(4),
          Text(
            'Pick your preferred schedule',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(24),
          Text('Date', style: AppTypography.titleMedium),
          const Gap(12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableDates.length,
              separatorBuilder: (_, __) => const Gap(10),
              itemBuilder: (context, index) {
                final date = _availableDates[index];
                final isSelected = date.day == _selectedDate.day &&
                    date.month == _selectedDate.month;
                final isToday = date.day == DateTime.now().day;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date),
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected ? Colors.white70 : AppColors.textSecondary,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '${date.day}',
                          style: AppTypography.titleLarge.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isToday)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.white : AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(28),
          Text('Time', style: AppTypography.titleMedium),
          const Gap(12),
          TimeSlotPicker(
            selectedTime: _selectedTime,
            onTimeSelected: (time) => setState(() => _selectedTime = time),
          ),
        ],
      ),
    );
  }
}
