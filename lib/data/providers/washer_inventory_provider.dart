import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

final washerInventoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/employee/inventory');
  if (response.data['success'] == true) {
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  return [];
});

final washerSupplyRequestsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/employee/supply-requests');
  if (response.data['success'] == true) {
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  return [];
});

class WasherInventoryActions {
  final Ref _ref;
  WasherInventoryActions(this._ref);

  Future<String?> batchRequest(List<Map<String, dynamic>> items) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final res = await dio.post('/employee/inventory/batch-request', data: {
        'items': items,
      });
      if (res.data['success'] == true) {
        _ref.invalidate(washerSupplyRequestsProvider);
        return null;
      }
      return res.data['message'] ?? 'Batch request failed';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteSupplyBatch(String batchId) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.delete('/employee/supply-requests/$batchId');
      if (response.data['success'] == true) {
        _ref.invalidate(washerSupplyRequestsProvider);
        return null;
      }
      return response.data['message'] ?? 'Delete failed';
    } catch (e) {
      return e.toString();
    }
  }
}

final washerInventoryActionsProvider = Provider((ref) => WasherInventoryActions(ref));