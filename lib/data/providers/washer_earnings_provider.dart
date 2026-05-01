import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

// Provider for a specific date (pass date string 'YYYY-MM-DD' or null for summary)
final washerEarningsProvider = FutureProvider.family<Map<String, dynamic>, String?>((ref, date) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final queryParams = <String, dynamic>{};
  if (date != null) {
    queryParams['date'] = date;
  }
  final response = await dio.get('/employee/earnings', queryParameters: queryParams);
  if (response.data['success'] == true) {
    return response.data['data'];
  }
  return {};
});