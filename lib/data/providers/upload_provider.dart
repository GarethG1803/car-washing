import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clean_ride/core/network/api_client.dart';

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(ref.read(apiClientProvider));
});

class UploadService {
  final Dio _dio;
  UploadService(this._dio);

  Future<String> uploadImage(XFile file) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path, filename: file.name),
    });
    final response = await _dio.post('/upload', data: formData);
    if (response.data['success'] == true) {
      return response.data['data']['url'] as String;
    }
    throw Exception(response.data['message'] ?? 'Upload failed');
  }
}
