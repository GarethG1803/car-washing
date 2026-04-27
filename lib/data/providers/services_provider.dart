import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/data/models/service_package.dart';

final servicesProvider = FutureProvider<List<ServicePackage>>((ref) async {
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/services');
  if (response.data['success'] == true) {
    final data = response.data['data'] as List;
    return data
        .map((json) =>
            ServicePackage.fromApiJson(json as Map<String, dynamic>))
        .toList();
  }
  return [];
});

final serviceDetailProvider =
    FutureProvider.family<ServicePackage?, String>((ref, id) async {
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/services/$id');
  if (response.data['success'] == true) {
    return ServicePackage.fromApiJson(
        response.data['data'] as Map<String, dynamic>);
  }
  return null;
});
