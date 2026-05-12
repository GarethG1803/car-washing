import 'package:flutter/foundation.dart';

enum BookingStatus {
  pending,
  confirmed,
  washerEnRoute,
  inProgress,
  completed,
  cancelled,
}

@immutable
class Booking {
  final String id;
  final String customerId;
  final String? customerName;
  final String? customerPhone;
  final String? customerAvatar;
  final String? washerId;
  final String? washerName;
  final String? washerPhone;
  final String? washerAvatar;
  final String vehicleId;
  final String servicePackageId;
  final List<String> addonIds;
  final BookingStatus status;
  final DateTime scheduledDate;
  final String timeSlot;
  final String address;
  final double latitude;
  final double longitude;
  final double totalAmount;
  final double? tip;
  final String? notes;
  final String? serviceName;
  final String? paymentStatus;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Booking({
    required this.id,
    required this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerAvatar,
    this.washerId,
    this.washerName,
    this.washerPhone,
    this.washerAvatar,
    required this.vehicleId,
    required this.servicePackageId,
    required this.addonIds,
    required this.status,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.totalAmount,
    this.tip,
    this.notes,
    this.serviceName,
    this.paymentStatus,
    required this.createdAt,
    this.completedAt,
  });

  bool get needsPayment =>
      status == BookingStatus.completed && paymentStatus != 'paid';

  String get shortId =>
      id.length >= 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase();

  Booking copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAvatar,
    String? washerId,
    String? washerName,
    String? washerPhone,
    String? washerAvatar,
    String? vehicleId,
    String? servicePackageId,
    List<String>? addonIds,
    BookingStatus? status,
    DateTime? scheduledDate,
    String? timeSlot,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAmount,
    double? tip,
    String? notes,
    String? serviceName,
    String? paymentStatus,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAvatar: customerAvatar ?? this.customerAvatar,
      washerId: washerId ?? this.washerId,
      washerName: washerName ?? this.washerName,
      washerPhone: washerPhone ?? this.washerPhone,
      washerAvatar: washerAvatar ?? this.washerAvatar,
      vehicleId: vehicleId ?? this.vehicleId,
      servicePackageId: servicePackageId ?? this.servicePackageId,
      addonIds: addonIds ?? this.addonIds,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalAmount: totalAmount ?? this.totalAmount,
      tip: tip ?? this.tip,
      notes: notes ?? this.notes,
      serviceName: serviceName ?? this.serviceName,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          customerId == other.customerId &&
          customerName == other.customerName &&
          customerPhone == other.customerPhone &&
          customerAvatar == other.customerAvatar &&
          washerId == other.washerId &&
          washerName == other.washerName &&
          washerPhone == other.washerPhone &&
          washerAvatar == other.washerAvatar &&
          vehicleId == other.vehicleId &&
          servicePackageId == other.servicePackageId &&
          listEquals(addonIds, other.addonIds) &&
          status == other.status &&
          scheduledDate == other.scheduledDate &&
          timeSlot == other.timeSlot &&
          address == other.address &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          totalAmount == other.totalAmount &&
          tip == other.tip &&
          notes == other.notes &&
          serviceName == other.serviceName &&
          paymentStatus == other.paymentStatus &&
          createdAt == other.createdAt &&
          completedAt == other.completedAt;

  @override
  int get hashCode => Object.hashAll([
        id,
        customerId,
        customerName,
        customerPhone,
        customerAvatar,
        washerId,
        washerName,
        washerPhone,
        washerAvatar,
        vehicleId,
        servicePackageId,
        Object.hashAll(addonIds),
        status,
        scheduledDate,
        timeSlot,
        address,
        latitude,
        longitude,
        totalAmount,
        tip,
        notes,
        serviceName,
        paymentStatus,
        createdAt,
        completedAt,
      ]);

  @override
  String toString() =>
      'Booking(id: $id, customerId: $customerId, customerName: $customerName, '
      'washerId: $washerId, washerName: $washerName, '
      'vehicleId: $vehicleId, servicePackageId: $servicePackageId, '
      'status: $status, scheduledDate: $scheduledDate, '
      'address: $address, totalAmount: $totalAmount, '
      'paymentStatus: $paymentStatus)';

  factory Booking.fromApiJson(Map<String, dynamic> json) {
    // Support both nested objects (customer: {...}) and flat fields
    // (customer_name) — different endpoints use different shapes.
    final customer = json['customer'];
    final customerJson =
        customer is Map<String, dynamic> ? customer : const <String, dynamic>{};
    final washer = json['washer'] ?? json['assigned_employee'];
    final washerJson =
        washer is Map<String, dynamic> ? washer : const <String, dynamic>{};

    BookingStatus status;
    switch (json['status']?.toString()) {
      case 'confirmed':
        status = BookingStatus.confirmed;
      case 'on_the_way':
        status = BookingStatus.washerEnRoute;
      case 'in_progress':
        status = BookingStatus.inProgress;
      case 'done':
        status = BookingStatus.completed;
      case 'cancelled':
        status = BookingStatus.cancelled;
      default:
        status = BookingStatus.pending;
    }
    final scheduledAt = json['scheduled_at'] != null
        ? DateTime.parse(json['scheduled_at'].toString())
        : DateTime.now();
    return Booking(
      id: json['id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ??
          customerJson['id']?.toString() ??
          '',
      customerName: json['customer_name']?.toString() ??
          customerJson['name']?.toString(),
      customerPhone: json['customer_phone']?.toString() ??
          customerJson['phone']?.toString(),
      customerAvatar: json['customer_avatar']?.toString() ??
          customerJson['avatar_url']?.toString(),
      washerId: json['assigned_employee_id']?.toString() ??
          washerJson['id']?.toString(),
      washerName: json['washer_name']?.toString() ??
          washerJson['name']?.toString(),
      washerPhone: json['washer_phone']?.toString() ??
          washerJson['phone']?.toString(),
      washerAvatar: json['washer_avatar']?.toString() ??
          washerJson['avatar_url']?.toString(),
      vehicleId: json['vehicle_plate']?.toString() ?? '',
      servicePackageId: json['service_id']?.toString() ?? '',
      addonIds: const [],
      status: status,
      scheduledDate: scheduledAt,
      timeSlot:
          '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}',
      address: json['location_address']?.toString() ?? '',
      latitude: (json['location_lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['location_lng'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes']?.toString(),
      serviceName: json['service_name']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }
}
