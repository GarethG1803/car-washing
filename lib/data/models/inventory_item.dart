import 'package:flutter/foundation.dart';

enum StockStatus { inStock, lowStock, outOfStock }

@immutable
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int currentStock;
  final int minimumStock;
  final int maximumStock;
  final double unitPrice;
  final String unit;
  final StockStatus status;
  final DateTime lastRestocked;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.currentStock,
    required this.minimumStock,
    required this.maximumStock,
    required this.unitPrice,
    required this.unit,
    this.status = StockStatus.inStock,
    required this.lastRestocked,
  });

  /// Computed stock status based on currentStock vs minimumStock.
  StockStatus get computedStatus {
    if (currentStock <= 0) {
      return StockStatus.outOfStock;
    } else if (currentStock <= minimumStock) {
      return StockStatus.lowStock;
    } else {
      return StockStatus.inStock;
    }
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    int? currentStock,
    int? minimumStock,
    int? maximumStock,
    double? unitPrice,
    String? unit,
    StockStatus? status,
    DateTime? lastRestocked,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      currentStock: currentStock ?? this.currentStock,
      minimumStock: minimumStock ?? this.minimumStock,
      maximumStock: maximumStock ?? this.maximumStock,
      unitPrice: unitPrice ?? this.unitPrice,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      lastRestocked: lastRestocked ?? this.lastRestocked,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          category == other.category &&
          currentStock == other.currentStock &&
          minimumStock == other.minimumStock &&
          maximumStock == other.maximumStock &&
          unitPrice == other.unitPrice &&
          unit == other.unit &&
          status == other.status &&
          lastRestocked == other.lastRestocked;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        category,
        currentStock,
        minimumStock,
        maximumStock,
        unitPrice,
        unit,
        status,
        lastRestocked,
      );

  @override
  String toString() =>
      'InventoryItem(id: $id, name: $name, category: $category, '
      'currentStock: $currentStock, minimumStock: $minimumStock, '
      'maximumStock: $maximumStock, unitPrice: $unitPrice, unit: $unit, '
      'status: $status, lastRestocked: $lastRestocked)';
}
