import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/features/customer/booking/screens/select_vehicle_step.dart';
import 'package:clean_ride/features/customer/booking/screens/select_service_step.dart';
import 'package:clean_ride/features/customer/booking/screens/select_datetime_step.dart';
import 'package:clean_ride/features/customer/booking/screens/select_address_step.dart';
import 'package:clean_ride/features/customer/booking/screens/booking_summary_screen.dart';
import 'package:clean_ride/features/customer/booking/widgets/booking_stepper.dart';
import 'package:gap/gap.dart';

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 0;
  final _steps = ['Vehicle', 'Service', 'Date & Time', 'Address', 'Summary'];

  void _next() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      context.push('/customer/booking/confirmed');
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return const SelectVehicleStep();
      case 1:
        return const SelectServiceStep();
      case 2:
        return const SelectDatetimeStep();
      case 3:
        return const SelectAddressStep();
      case 4:
        return const BookingSummaryScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Book a Wash'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: BookingStepper(
              steps: _steps,
              currentStep: _currentStep,
            ),
          ),
          Expanded(child: _buildStep()),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _back,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              if (_currentStep > 0) const Gap(12),
              Expanded(
                flex: _currentStep == 0 ? 1 : 1,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: Text(
                    _currentStep == _steps.length - 1 ? 'Confirm Booking' : 'Continue',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
