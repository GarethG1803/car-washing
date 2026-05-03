import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

// Finance summary: today, week, month, all_time platform revenue
final adminFinanceProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/admin/finance');
  if (response.data['success'] == true) {
    return response.data['data'];
  }
  return {};
});

// Chart data: daily revenue for the last 30 days
final adminFinanceChartProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/admin/finance/chart');
  if (response.data['success'] == true) {
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  return [];
});

// Settings (commission rate)
final adminSettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/admin/settings');
  if (response.data['success'] == true) {
    return response.data['data'];
  }
  return {};
});

// Transaction list for invoice screen
final adminTransactionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/admin/transactions');
  if (response.data['success'] == true) {
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  return [];
});
