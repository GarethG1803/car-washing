import 'package:flutter/foundation.dart';

@immutable
class Review {
  final String id;
  final String bookingId;
  final String customerId;
  final String washerId;
  final double rating;
  final String? comment;
  final String customerName;
  final String? customerAvatar;
  final DateTime createdAt;
  final List<String> photos;

  const Review({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.washerId,
    required this.rating,
    this.comment,
    required this.customerName,
    this.customerAvatar,
    required this.createdAt,
    required this.photos,
  });

  Review copyWith({
    String? id,
    String? bookingId,
    String? customerId,
    String? washerId,
    double? rating,
    String? comment,
    String? customerName,
    String? customerAvatar,
    DateTime? createdAt,
    List<String>? photos,
  }) {
    return Review(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerId: customerId ?? this.customerId,
      washerId: washerId ?? this.washerId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      customerName: customerName ?? this.customerName,
      customerAvatar: customerAvatar ?? this.customerAvatar,
      createdAt: createdAt ?? this.createdAt,
      photos: photos ?? this.photos,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Review &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bookingId == other.bookingId &&
          customerId == other.customerId &&
          washerId == other.washerId &&
          rating == other.rating &&
          comment == other.comment &&
          customerName == other.customerName &&
          customerAvatar == other.customerAvatar &&
          createdAt == other.createdAt &&
          listEquals(photos, other.photos);

  @override
  int get hashCode => Object.hash(
        id,
        bookingId,
        customerId,
        washerId,
        rating,
        comment,
        customerName,
        customerAvatar,
        createdAt,
        Object.hashAll(photos),
      );

  @override
  String toString() =>
      'Review(id: $id, bookingId: $bookingId, customerId: $customerId, '
      'washerId: $washerId, rating: $rating, comment: $comment, '
      'customerName: $customerName, customerAvatar: $customerAvatar, '
      'createdAt: $createdAt, photos: $photos)';
}
