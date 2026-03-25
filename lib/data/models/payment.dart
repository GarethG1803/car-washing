import 'package:flutter/foundation.dart';

enum PaymentMethod { creditCard, debitCard, wallet, cash }

enum PaymentStatus { pending, completed, failed, refunded }

@immutable
class Payment {
  final String id;
  final String bookingId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? cardLast4;
  final String? cardBrand;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.method,
    required this.status,
    this.cardLast4,
    this.cardBrand,
    required this.createdAt,
  });

  Payment copyWith({
    String? id,
    String? bookingId,
    double? amount,
    PaymentMethod? method,
    PaymentStatus? status,
    String? cardLast4,
    String? cardBrand,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      cardLast4: cardLast4 ?? this.cardLast4,
      cardBrand: cardBrand ?? this.cardBrand,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Payment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bookingId == other.bookingId &&
          amount == other.amount &&
          method == other.method &&
          status == other.status &&
          cardLast4 == other.cardLast4 &&
          cardBrand == other.cardBrand &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        bookingId,
        amount,
        method,
        status,
        cardLast4,
        cardBrand,
        createdAt,
      );

  @override
  String toString() =>
      'Payment(id: $id, bookingId: $bookingId, amount: $amount, '
      'method: $method, status: $status, cardLast4: $cardLast4, '
      'cardBrand: $cardBrand, createdAt: $createdAt)';
}
