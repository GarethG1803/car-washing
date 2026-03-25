import 'package:flutter/foundation.dart';

@immutable
class WasherProfile {
  final String id;
  final String userId;
  final String name;
  final String? avatarUrl;
  final String phone;
  final double rating;
  final int totalJobs;
  final int completedJobs;
  final double earnings;
  final bool isAvailable;
  final bool isOnline;
  final List<String> specialties;
  final DateTime joinedDate;
  final bool documentsVerified;

  const WasherProfile({
    required this.id,
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.phone,
    this.rating = 0.0,
    this.totalJobs = 0,
    this.completedJobs = 0,
    this.earnings = 0.0,
    this.isAvailable = true,
    this.isOnline = false,
    required this.specialties,
    required this.joinedDate,
    this.documentsVerified = false,
  });

  WasherProfile copyWith({
    String? id,
    String? userId,
    String? name,
    String? avatarUrl,
    String? phone,
    double? rating,
    int? totalJobs,
    int? completedJobs,
    double? earnings,
    bool? isAvailable,
    bool? isOnline,
    List<String>? specialties,
    DateTime? joinedDate,
    bool? documentsVerified,
  }) {
    return WasherProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      totalJobs: totalJobs ?? this.totalJobs,
      completedJobs: completedJobs ?? this.completedJobs,
      earnings: earnings ?? this.earnings,
      isAvailable: isAvailable ?? this.isAvailable,
      isOnline: isOnline ?? this.isOnline,
      specialties: specialties ?? this.specialties,
      joinedDate: joinedDate ?? this.joinedDate,
      documentsVerified: documentsVerified ?? this.documentsVerified,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WasherProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          phone == other.phone &&
          rating == other.rating &&
          totalJobs == other.totalJobs &&
          completedJobs == other.completedJobs &&
          earnings == other.earnings &&
          isAvailable == other.isAvailable &&
          isOnline == other.isOnline &&
          listEquals(specialties, other.specialties) &&
          joinedDate == other.joinedDate &&
          documentsVerified == other.documentsVerified;

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        name,
        avatarUrl,
        phone,
        rating,
        totalJobs,
        completedJobs,
        earnings,
        isAvailable,
        isOnline,
        Object.hashAll(specialties),
        joinedDate,
        documentsVerified,
      ]);

  @override
  String toString() =>
      'WasherProfile(id: $id, userId: $userId, name: $name, '
      'avatarUrl: $avatarUrl, phone: $phone, rating: $rating, '
      'totalJobs: $totalJobs, completedJobs: $completedJobs, '
      'earnings: $earnings, isAvailable: $isAvailable, isOnline: $isOnline, '
      'specialties: $specialties, joinedDate: $joinedDate, '
      'documentsVerified: $documentsVerified)';
}
