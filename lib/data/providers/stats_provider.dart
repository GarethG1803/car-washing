import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

final orderStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/orders/stats');
  if (response.data['success'] == true) {
    return response.data['data'] as Map<String, dynamic>;
  }
  return {};
});
