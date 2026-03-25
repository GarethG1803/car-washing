import 'package:flutter/foundation.dart';

enum InvoiceStatus { draft, sent, paid, overdue }

@immutable
class InvoiceLineItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double total;

  const InvoiceLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  InvoiceLineItem copyWith({
    String? description,
    int? quantity,
    double? unitPrice,
    double? total,
  }) {
    return InvoiceLineItem(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      total: total ?? this.total,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceLineItem &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          quantity == other.quantity &&
          unitPrice == other.unitPrice &&
          total == other.total;

  @override
  int get hashCode => Object.hash(description, quantity, unitPrice, total);

  @override
  String toString() =>
      'InvoiceLineItem(description: $description, quantity: $quantity, '
      'unitPrice: $unitPrice, total: $total)';
}

@immutable
class Invoice {
  final String id;
  final String bookingId;
  final String customerName;
  final double amount;
  final double tax;
  final double total;
  final InvoiceStatus status;
  final DateTime issuedDate;
  final DateTime dueDate;
  final List<InvoiceLineItem> items;

  const Invoice({
    required this.id,
    required this.bookingId,
    required this.customerName,
    required this.amount,
    required this.tax,
    required this.total,
    required this.status,
    required this.issuedDate,
    required this.dueDate,
    required this.items,
  });

  Invoice copyWith({
    String? id,
    String? bookingId,
    String? customerName,
    double? amount,
    double? tax,
    double? total,
    InvoiceStatus? status,
    DateTime? issuedDate,
    DateTime? dueDate,
    List<InvoiceLineItem>? items,
  }) {
    return Invoice(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      issuedDate: issuedDate ?? this.issuedDate,
      dueDate: dueDate ?? this.dueDate,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Invoice &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bookingId == other.bookingId &&
          customerName == other.customerName &&
          amount == other.amount &&
          tax == other.tax &&
          total == other.total &&
          status == other.status &&
          issuedDate == other.issuedDate &&
          dueDate == other.dueDate &&
          listEquals(items, other.items);

  @override
  int get hashCode => Object.hash(
        id,
        bookingId,
        customerName,
        amount,
        tax,
        total,
        status,
        issuedDate,
        dueDate,
        Object.hashAll(items),
      );

  @override
  String toString() =>
      'Invoice(id: $id, bookingId: $bookingId, customerName: $customerName, '
      'amount: $amount, tax: $tax, total: $total, status: $status, '
      'issuedDate: $issuedDate, dueDate: $dueDate, items: $items)';
}
