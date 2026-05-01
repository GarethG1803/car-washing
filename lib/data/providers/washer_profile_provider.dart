import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';
import 'package:clean_ride/data/models/washer_profile.dart';

final washerProfileProvider = FutureProvider<WasherProfile>((ref) async {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  final response = await dio.get('/employee/profile');
  if (response.data['success'] == true) {
    final data = response.data['data'];
    return WasherProfile(
      id: data['id'],
      userId: data['id'],
      name: data['name'],
      phone: data['phone'] ?? '',
      rating: 4.9, // backend doesn't track ratings yet
      totalJobs: data['total_jobs'] ?? 0,
      completedJobs: data['completed_jobs'] ?? 0,
      earnings: (data['earnings'] ?? 0).toDouble(),
      specialties: ['Premium Detail', 'Ceramic Coating', 'Paint Correction'], // future
      joinedDate: DateTime.tryParse(data['joined_date']?.toString() ?? '') ?? DateTime.now(),
    );
  }
  throw Exception('Failed to load profile');
});