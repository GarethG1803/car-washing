import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = StateProvider<String?>((ref) => null);

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://carwash-api.brevonsolutions.com',
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
