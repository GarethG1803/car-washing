import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/data/models/booking.dart';

/// Customer: re-runs when token changes (login/logout).
final customerOrdersProvider = FutureProvider<List<Booking>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/orders/my');
  if (response.data['success'] == true) {
    final data = response.data['data'] as List;
    return data
        .map((json) => Booking.fromApiJson(json as Map<String, dynamic>))
        .toList();
  }
  return [];
});

/// Customer: fetch a single order with status history.
final orderDetailProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/orders/my/$id');
  if (response.data['success'] == true) {
    return response.data['data'] as Map<String, dynamic>;
  }
  return null;
});
