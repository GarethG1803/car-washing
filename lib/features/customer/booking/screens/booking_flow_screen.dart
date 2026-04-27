import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/booking_state_provider.dart';
import 'package:clean_ride/features/customer/booking/screens/select_vehicle_step.dart';
import 'package:clean_ride/features/customer/booking/screens/select_service_step.dart';
import 'package:clean_ride/features/customer/booking/screens/select_datetime_step.dart';
import 'package:clean_ride/features/customer/booking/screens/select_address_step.dart';
import 'package:clean_ride/features/customer/booking/screens/booking_summary_screen.dart';
import 'package:clean_ride/features/customer/booking/widgets/booking_stepper.dart';
import 'package:gap/gap.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  int _currentStep = 0;
  final _steps = ['Vehicle', 'Service', 'Date & Time', 'Address', 'Summary'];

  bool _canProceed(BookingFormState state) {
    switch (_currentStep) {
      case 0:
        return state.vehiclePlate.trim().isNotEmpty;
      case 1:
        return state.serviceId != null;
      case 2:
        return state.scheduledAt != null;
      case 3:
        return state.locationAddress.trim().isNotEmpty;
      default:
        return true;
    }
  }

  Future<void> _next() async {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      return;
    }
    final error = await ref.read(bookingStateProvider.notifier).submit();
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }
    context.go('/customer/booking/confirmed');
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
    final bookingState = ref.watch(bookingStateProvider);
    final isSubmitting = bookingState.isSubmitting;
    final canProceed = _canProceed(bookingState);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Book a Wash'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: isSubmitting ? null : _back,
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
              if (_currentStep > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSubmitting ? null : _back,
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
                const Gap(12),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: (canProceed && !isSubmitting) ? _next : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.divider,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          _currentStep == _steps.length - 1
                              ? 'Confirm Booking'
                              : 'Continue',
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
