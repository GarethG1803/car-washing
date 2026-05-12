import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clean_ride/core/network/api_client.dart';

const _uploadBase = 'https://carwash-api.brevonsolutions.com';

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(ref);
});

class UploadService {
  final Ref _ref;
  UploadService(this._ref);

  Future<String> uploadImage(XFile file) async {
    final token = _ref.read(tokenProvider);
    final bytes = await file.readAsBytes();

    final name = file.name.isNotEmpty ? file.name : 'upload.jpg';
    final mimeType = file.mimeType ?? _mimeForName(name);
    final parts = mimeType.split('/');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_uploadBase/upload'),
    );
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: name,
        contentType: MediaType(parts[0], parts.length > 1 ? parts[1] : 'jpeg'),
      ),
    );

    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    if (json['success'] == true) {
      return (json['data'] as Map<String, dynamic>)['url'] as String;
    }
    throw Exception(json['message'] ?? 'Upload failed');
  }

  static String _mimeForName(String name) {
    final ext = name.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }
}
