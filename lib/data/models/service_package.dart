import 'package:flutter/foundation.dart';

enum ServiceCategory { basic, premium, deluxe, addon }

@immutable
class ServicePackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;
  final ServiceCategory category;
  final List<String> features;
  final String? imageUrl;
  final bool isPopular;
  final double rating;

  const ServicePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.features,
    this.imageUrl,
    this.isPopular = false,
    this.rating = 0.0,
  });

  ServicePackage copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? duration,
    ServiceCategory? category,
    List<String>? features,
    String? imageUrl,
    bool? isPopular,
    double? rating,
  }) {
    return ServicePackage(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      features: features ?? this.features,
      imageUrl: imageUrl ?? this.imageUrl,
      isPopular: isPopular ?? this.isPopular,
      rating: rating ?? this.rating,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServicePackage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          price == other.price &&
          duration == other.duration &&
          category == other.category &&
          listEquals(features, other.features) &&
          imageUrl == other.imageUrl &&
          isPopular == other.isPopular &&
          rating == other.rating;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        price,
        duration,
        category,
        Object.hashAll(features),
        imageUrl,
        isPopular,
        rating,
      );

  @override
  String toString() =>
      'ServicePackage(id: $id, name: $name, description: $description, '
      'price: $price, duration: $duration, category: $category, '
      'features: $features, imageUrl: $imageUrl, isPopular: $isPopular, '
      'rating: $rating)';
}
