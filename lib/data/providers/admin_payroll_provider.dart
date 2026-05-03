import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

final adminPayrollProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/admin/payroll');
  if (response.data['success'] == true) {
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  return [];
});
