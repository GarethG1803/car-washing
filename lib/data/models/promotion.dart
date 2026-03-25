import 'package:flutter/foundation.dart';

enum DiscountType { percentage, fixed }

@immutable
class Promotion {
  final String id;
  final String title;
  final String description;
  final String code;
  final DiscountType discountType;
  final double discountValue;
  final double? minimumOrder;
  final int maxUses;
  final int currentUses;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String? imageUrl;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.minimumOrder,
    required this.maxUses,
    this.currentUses = 0,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.imageUrl,
  });

  Promotion copyWith({
    String? id,
    String? title,
    String? description,
    String? code,
    DiscountType? discountType,
    double? discountValue,
    double? minimumOrder,
    int? maxUses,
    int? currentUses,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? imageUrl,
  }) {
    return Promotion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      maxUses: maxUses ?? this.maxUses,
      currentUses: currentUses ?? this.currentUses,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Promotion &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          code == other.code &&
          discountType == other.discountType &&
          discountValue == other.discountValue &&
          minimumOrder == other.minimumOrder &&
          maxUses == other.maxUses &&
          currentUses == other.currentUses &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          isActive == other.isActive &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        description,
        code,
        discountType,
        discountValue,
        minimumOrder,
        maxUses,
        currentUses,
        startDate,
        endDate,
        isActive,
        imageUrl,
      ]);

  @override
  String toString() =>
      'Promotion(id: $id, title: $title, description: $description, '
      'code: $code, discountType: $discountType, discountValue: $discountValue, '
      'minimumOrder: $minimumOrder, maxUses: $maxUses, '
      'currentUses: $currentUses, startDate: $startDate, endDate: $endDate, '
      'isActive: $isActive, imageUrl: $imageUrl)';
}
