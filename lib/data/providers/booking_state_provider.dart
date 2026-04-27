import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:dio/dio.dart';

class BookingFormState {
  final String vehiclePlate;
  final String vehicleType;
  final String? serviceId;
  final DateTime? scheduledAt;
  final String locationAddress;
  final String? notes;
  final bool isSubmitting;
  final String? error;

  const BookingFormState({
    this.vehiclePlate = '',
    this.vehicleType = 'sedan',
    this.serviceId,
    this.scheduledAt,
    this.locationAddress = '',
    this.notes,
    this.isSubmitting = false,
    this.error,
  });

  BookingFormState copyWith({
    String? vehiclePlate,
    String? vehicleType,
    String? serviceId,
    DateTime? scheduledAt,
    String? locationAddress,
    String? notes,
    bool? isSubmitting,
    String? error,
  }) {
    return BookingFormState(
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      vehicleType: vehicleType ?? this.vehicleType,
      serviceId: serviceId ?? this.serviceId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      locationAddress: locationAddress ?? this.locationAddress,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  bool get isValid =>
      vehiclePlate.trim().isNotEmpty &&
      serviceId != null &&
      scheduledAt != null &&
      locationAddress.trim().isNotEmpty;
}

class BookingNotifier extends StateNotifier<BookingFormState> {
  BookingNotifier(this._ref) : super(const BookingFormState());

  final Ref _ref;

  void setVehicle(String plate, String type) {
    state = state.copyWith(vehiclePlate: plate, vehicleType: type);
  }

  void setService(String id) {
    state = state.copyWith(serviceId: id);
  }

  void setSchedule(DateTime dt) {
    state = state.copyWith(scheduledAt: dt);
  }

  void setAddress(String address, {String? notes}) {
    state = state.copyWith(locationAddress: address, notes: notes);
  }

  void reset() {
    state = const BookingFormState();
  }

  Future<String?> submit() async {
    if (!state.isValid) return 'Please fill in all required fields';
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.post('/orders', data: {
        'service_id': state.serviceId,
        'vehicle_plate': state.vehiclePlate.trim(),
        'vehicle_type': state.vehicleType,
        'location_address': state.locationAddress.trim(),
        'scheduled_at': state.scheduledAt!.toUtc().toIso8601String(),
        if (state.notes != null && state.notes!.trim().isNotEmpty)
          'notes': state.notes!.trim(),
      });
      if (response.data['success'] == true) {
        _ref.read(lastCreatedOrderProvider.notifier).state =
            response.data['data'] as Map<String, dynamic>?;
        state = state.copyWith(isSubmitting: false);
        reset();
        return null;
      }
      final msg =
          response.data['message']?.toString() ?? 'Booking failed';
      state = state.copyWith(isSubmitting: false, error: msg);
      return msg;
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Network error';
      state = state.copyWith(isSubmitting: false, error: msg);
      return msg;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return e.toString();
    }
  }
}

final bookingStateProvider =
    StateNotifierProvider<BookingNotifier, BookingFormState>(
  (ref) => BookingNotifier(ref),
);

final lastCreatedOrderProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);
