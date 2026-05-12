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

final washerJobsProvider = FutureProvider<List<Booking>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/orders/assigned');
  if (response.data['success'] == true) {
    final data = response.data['data'] as List;
    return data
        .map((json) => Booking.fromApiJson(json as Map<String, dynamic>))
        .toList();
  }
  return [];
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
