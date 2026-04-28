import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/data/models/user.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:dio/dio.dart';

final currentUserProvider = StateProvider<User?>((ref) => null);

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(currentUserProvider) != null,
);

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final token = data['token'] as String;
        final user = User.fromJson(data['user'] as Map<String, dynamic>);
        ref.read(tokenProvider.notifier).state = token;
        ref.read(currentUserProvider.notifier).state = user;
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.data['message'] ?? 'Login failed',
          StackTrace.current,
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Network error';
      state = AsyncValue.error(errorMessage, StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': 'customer',
      });

      if (response.data['success'] == true) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.data['message'] ?? 'Registration failed',
          StackTrace.current,
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? e.message ?? 'Network error';
      state = AsyncValue.error(errorMessage, StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  void logout() {
    ref.read(tokenProvider.notifier).state = null;
    ref.read(currentUserProvider.notifier).state = null;
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, void>(() => AuthNotifier());
