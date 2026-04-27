import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

// Fetches users list. Pass role='employee'|'customer'|'admin' or null for all.
final usersProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>(
    (ref, role) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get(
    '/users',
    queryParameters: role != null ? {'role': role} : null,
  );
  if (response.data['success'] == true) {
    return (response.data['data'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }
  return [];
});

final userDetailProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/users/$id');
  if (response.data['success'] == true) {
    return response.data['data'] as Map<String, dynamic>;
  }
  return null;
});
