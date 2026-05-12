import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/data/models/booking.dart';

String _friendlyError(Object e, String fallback) {
  if (e is DioException) {
    final body = e.response?.data;
    if (body is Map && body['message'] is String) return body['message'] as String;
    return e.message ?? fallback;
  }
  return fallback;
}

/// Customer: list of my orders. Auto-refreshes every 25s while the provider
/// has listeners, so customers see washer status changes without manually
/// pulling to refresh.
final customerOrdersProvider =
    StreamProvider<List<Booking>>((ref) async* {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  var disposed = false;
  ref.onDispose(() => disposed = true);

  Future<List<Booking>> fetch() async {
    if (ref.read(tokenProvider) == null) return const [];
    try {
      final response = await dio.get('/orders/my');
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

/// Customer: single-order detail with history. Polls every 20s.
final orderDetailProvider =
    StreamProvider.family<Map<String, dynamic>?, String>((ref, id) async* {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  var disposed = false;
  ref.onDispose(() => disposed = true);

  Future<Map<String, dynamic>?> fetch() async {
    if (ref.read(tokenProvider) == null) return null;
    try {
      final response = await dio.get('/orders/my/$id');
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

/// Customer self-cancel — returns null on success or error message string.
final customerOrderActionsProvider =
    Provider((ref) => _CustomerOrderActions(ref));

class _CustomerOrderActions {
  final Ref _ref;
  _CustomerOrderActions(this._ref);

  Future<String?> cancel(String orderId, {String? reason}) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.post(
        '/orders/my/$orderId/cancel',
        data: {if (reason != null) 'reason': reason},
      );
      if (response.data['success'] == true) {
        _ref.invalidate(customerOrdersProvider);
        _ref.invalidate(orderDetailProvider(orderId));
        return null;
      }
      return response.data['message']?.toString() ?? 'Cancel failed';
    } catch (e) {
      return _friendlyError(e, 'Could not cancel');
    }
  }
}
