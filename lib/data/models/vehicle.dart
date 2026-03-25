import 'package:flutter/foundation.dart';

enum VehicleType { sedan, suv, truck, van, coupe, hatchback }

@immutable
class Vehicle {
  final String id;
  final String userId;
  final String make;
  final String model;
  final int year;
  final String color;
  final String licensePlate;
  final VehicleType type;
  final String? imageUrl;
  final bool isDefault;

  const Vehicle({
    required this.id,
    required this.userId,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.type,
    this.imageUrl,
    this.isDefault = false,
  });

  Vehicle copyWith({
    String? id,
    String? userId,
    String? make,
    String? model,
    int? year,
    String? color,
    String? licensePlate,
    VehicleType? type,
    String? imageUrl,
    bool? isDefault,
  }) {
    return Vehicle(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          make == other.make &&
          model == other.model &&
          year == other.year &&
          color == other.color &&
          licensePlate == other.licensePlate &&
          type == other.type &&
          imageUrl == other.imageUrl &&
          isDefault == other.isDefault;

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        make,
        model,
        year,
        color,
        licensePlate,
        type,
        imageUrl,
        isDefault,
      );

  @override
  String toString() =>
      'Vehicle(id: $id, userId: $userId, make: $make, model: $model, '
      'year: $year, color: $color, licensePlate: $licensePlate, '
      'type: $type, imageUrl: $imageUrl, isDefault: $isDefault)';
}
