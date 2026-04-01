import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/data/models/user.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:dio/dio.dart';

/// Holds the currently logged-in user (null when unauthenticated).
final currentUserProvider = StateProvider<User?>((ref) => null);

/// Convenience provider that derives auth state from [currentUserProvider].
final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(currentUserProvider) != null,
);

/// Tracks the role selected on the role-selection screen.
/// This is separate from the router-level [roleProvider] and can be used
/// in feature-level widgets that need role awareness.
final selectedRoleProvider = StateProvider<UserRole?>((ref) => null);

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initial state
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success'] == true) {
        final userData = response.data['data']['user'];
        final user = User.fromJson(userData);
        ref.read(currentUserProvider.notifier).state = user;
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          response.data['message'] ?? 'Login failed',
          StackTrace.current,
        );
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Network error';
      state = AsyncValue.error(errorMessage, StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(() => AuthNotifier());
