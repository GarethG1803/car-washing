import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/data/models/booking.dart';

String _friendly(Object e) {
  if (e is DioException) {
    final body = e.response?.data;
    if (body is Map && body['message'] is String) return body['message'] as String;
    return e.message ?? 'Network error';
  }
  return e.toString();
}

/// Washer: assigned jobs. Polls every 25s so new admin assignments and
/// status changes appear without manual refresh.
final washerJobsProvider = StreamProvider<List<Booking>>((ref) async* {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  var disposed = false;
  ref.onDispose(() => disposed = true);

  Future<List<Booking>> fetch() async {
    if (ref.read(tokenProvider) == null) return const [];
    try {
      final response = await dio.get('/orders/assigned');
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

class WasherJobActions {
  final Ref _ref;
  WasherJobActions(this._ref);

  Future<String?> updateStatus(
    String orderId,
    String newStatus, {
    String? reason,
    String? beforePhotoUrl,
    String? afterPhotoUrl,
  }) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.patch(
        '/orders/$orderId/status',
        data: {
          'status': newStatus,
          if (reason != null) 'reason': reason,
          if (beforePhotoUrl != null) 'before_photo_url': beforePhotoUrl,
          if (afterPhotoUrl != null) 'after_photo_url': afterPhotoUrl,
        },
      );
      if (response.data['success'] == true) {
        _ref.invalidate(washerJobsProvider);
        return null;
      }
      return response.data['message']?.toString() ?? 'Failed to update status';
    } catch (e) {
      return _friendly(e);
    }
  }

  Future<String?> accept(String orderId) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.post('/orders/assigned/$orderId/accept');
      if (response.data['success'] == true) {
        _ref.invalidate(washerJobsProvider);
        return null;
      }
      return response.data['message']?.toString() ?? 'Accept failed';
    } catch (e) {
      return _friendly(e);
    }
  }

  Future<String?> decline(String orderId, {String? reason}) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.post(
        '/orders/assigned/$orderId/decline',
        data: {if (reason != null) 'reason': reason},
      );
      if (response.data['success'] == true) {
        _ref.invalidate(washerJobsProvider);
        return null;
      }
      return response.data['message']?.toString() ?? 'Decline failed';
    } catch (e) {
      return _friendly(e);
    }
  }
}

final washerJobActionsProvider = Provider((ref) => WasherJobActions(ref));
