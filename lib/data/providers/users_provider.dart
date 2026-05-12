import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:dio/dio.dart';

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

class UsersActions {
  UsersActions(this._ref);

  final Ref _ref;

  Future<String?> createWasher({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.post('/users/washers', data: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        if (address != null && address.trim().isNotEmpty)
          'address': address.trim(),
      });

      if (response.data['success'] == true) {
        return null;
      }

      return response.data['message']?.toString() ?? 'Could not add washer';
    } on DioException catch (e) {
      return e.response?.data?['message']?.toString() ??
          e.message ??
          'Network error';
    } catch (e) {
      return e.toString();
    }
  }
}

final usersActionsProvider = Provider((ref) => UsersActions(ref));
