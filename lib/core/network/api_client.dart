import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'token_storage.dart';

// --- Token Notifier that survives hot restarts ---
class TokenNotifier extends StateNotifier<String?> {
  TokenNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final stored = await TokenStorage.read();
    state = stored;
  }

  void setToken(String? token) {
    state = token;
    if (token != null) {
      TokenStorage.write(token);
    } else {
      TokenStorage.delete();
    }
  }
}

final tokenProvider = StateNotifierProvider<TokenNotifier, String?>((ref) {
  return TokenNotifier();
});

// --- API client (unchanged logic, but uses the new tokenProvider) ---
final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://carwash-api.brevonsolutions.com',
      // baseUrl: 'http://localhost:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(tokenProvider);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ),
  );

  return dio;
});
