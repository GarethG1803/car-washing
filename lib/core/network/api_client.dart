import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // Use 10.0.2.2 for Android emulator testing against localhost
      baseUrl: 'http://10.0.2.2:3000',
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
        // Here we could read from SharedPreferences and add Authorization header
        // if a token exists for future protected endpoints.
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ),
  );

  return dio;
});
