import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/data/models/booking.dart';

/// Admin: full orders list. Polls every 25s so new customer bookings appear
/// in the assignment queue without manual refresh.
final adminOrdersProvider = StreamProvider<List<Booking>>((ref) async* {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  var disposed = false;
  ref.onDispose(() => disposed = true);

  Future<List<Booking>> fetch() async {
    if (ref.read(tokenProvider) == null) return const [];
    try {
      final response = await dio.get('/orders');
      if (response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((j) => Booking.fromApiJson(j as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  yield await fetch();
  while (!disposed) {
    await Future<void>.delayed(const Duration(seconds: 25));
    if (disposed) break;
    yield await fetch();
  }
});

/// Admin: single order detail. Polls every 20s.
final adminOrderDetailProvider =
    StreamProvider.family<Map<String, dynamic>?, String>((ref, id) async* {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  var disposed = false;
  ref.onDispose(() => disposed = true);

  Future<Map<String, dynamic>?> fetch() async {
    if (ref.read(tokenProvider) == null) return null;
    try {
      final response = await dio.get('/orders/$id');
      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  yield await fetch();
  while (!disposed) {
    await Future<void>.delayed(const Duration(seconds: 20));
    if (disposed) break;
    yield await fetch();
  }
});

/// Extract the friendly `message` field from a Dio error response body when
/// the server returned a 4xx (validation, conflict, not-found). Falls back to
/// Dio's generic message if the response isn't shaped as `{message: ...}`.
String _friendly(Object e, String fallback) {
  if (e is DioException) {
    final body = e.response?.data;
    if (body is Map && body['message'] is String) {
      return body['message'] as String;
    }
    return e.message ?? fallback;
  }
  return fallback;
}

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
      return _friendly(e, 'Failed to cancel');
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
      return _friendly(e, 'Failed to assign washer');
    }
  }

  Future<String?> deleteOrder(String orderId) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.delete('/orders/$orderId');
      if (response.data['success'] == true) {
        _ref.invalidate(adminOrdersProvider);
        _ref.invalidate(adminOrderDetailProvider(orderId));
        return null;
      }
      return response.data['message'] ?? 'Failed to delete order';
    } catch (e) {
      return _friendly(e, 'Failed to delete order');
    }
  }
}

final adminOrderActionsProvider = Provider((ref) => AdminOrderActions(ref));
