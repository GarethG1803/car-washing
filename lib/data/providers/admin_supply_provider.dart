import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

final adminSupplyRequestsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/services/supply-requests');
  if (response.data['success'] == true) {
    return List<Map<String, dynamic>>.from(response.data['data']);
  }
  return [];
});

class AdminSupplyActions {
  final Ref _ref;
  AdminSupplyActions(this._ref);

  Future<String?> updateRequest(String requestId, String status) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.patch(
        '/services/supply-requests/$requestId',
        data: {'status': status},
      );
      if (response.data['success'] == true) {
        _ref.invalidate(adminSupplyRequestsProvider);
        return null;
      }
      return response.data['message'] ?? 'Failed to update';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteBatch(String batchId) async {
    try {
      final dio = _ref.read(apiClientProvider);
      final response = await dio.delete('/services/supply-requests/$batchId');
      if (response.data['success'] == true) {
        _ref.invalidate(adminSupplyRequestsProvider);
        return null;
      }
      return response.data['message'] ?? 'Delete failed';
    } catch (e) {
      return e.toString();
    }
  }
}

final adminSupplyActionsProvider = Provider((ref) => AdminSupplyActions(ref));