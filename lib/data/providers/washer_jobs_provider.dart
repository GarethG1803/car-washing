import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/data/models/booking.dart';

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

  Future<String?> updateStatus(String orderId, String newStatus) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.patch(
        '/orders/$orderId/status',
        data: {'status': newStatus},
      );
      if (response.data['success'] == true) {
        _ref.invalidate(washerJobsProvider);
        return null;
      }
      return response.data['message']?.toString() ?? 'Failed to update status';
    } catch (e) {
      return e.toString();
    }
  }
}

final washerJobActionsProvider = Provider((ref) => WasherJobActions(ref));
