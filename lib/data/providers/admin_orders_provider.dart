import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/data/models/booking.dart';

final adminOrdersProvider = FutureProvider<List<Booking>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/orders');
  if (response.data['success'] == true) {
    final data = response.data['data'] as List;
    return data
        .map((json) => Booking.fromApiJson(json as Map<String, dynamic>))
        .toList();
  }
  return [];
});

final adminOrderDetailProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/orders/$id');
  if (response.data['success'] == true) {
    return response.data['data'] as Map<String, dynamic>;
  }
  return null;
});

class AdminOrderActions {
  final Ref _ref;
  AdminOrderActions(this._ref);

  Future<String?> cancel(String orderId) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.patch('/orders/$orderId/cancel');
      if (response.data['success'] == true) {
        _ref.invalidate(adminOrdersProvider);
        _ref.invalidate(adminOrderDetailProvider(orderId));
        return null;
      }
      return response.data['message']?.toString() ?? 'Failed to cancel';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> assign(String orderId, String employeeId) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.patch(
        '/orders/$orderId/assign',
        data: {'employee_id': employeeId},
      );
      if (response.data['success'] == true) {
        _ref.invalidate(adminOrdersProvider);
        _ref.invalidate(adminOrderDetailProvider(orderId));
        return null;
      }
      return response.data['message']?.toString() ?? 'Failed to assign';
    } catch (e) {
      return e.toString();
    }
  }
}

final adminOrderActionsProvider = Provider((ref) => AdminOrderActions(ref));
