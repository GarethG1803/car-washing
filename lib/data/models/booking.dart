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
  final String? washerId;
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
  final DateTime createdAt;
  final DateTime? completedAt;

  const Booking({
    required this.id,
    required this.customerId,
    this.washerId,
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
    required this.createdAt,
    this.completedAt,
  });

  Booking copyWith({
    String? id,
    String? customerId,
    String? washerId,
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
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      washerId: washerId ?? this.washerId,
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
          washerId == other.washerId &&
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
          createdAt == other.createdAt &&
          completedAt == other.completedAt;

  @override
  int get hashCode => Object.hashAll([
        id,
        customerId,
        washerId,
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
        createdAt,
        completedAt,
      ]);

  @override
  String toString() =>
      'Booking(id: $id, customerId: $customerId, washerId: $washerId, '
      'vehicleId: $vehicleId, servicePackageId: $servicePackageId, '
      'addonIds: $addonIds, status: $status, scheduledDate: $scheduledDate, '
      'timeSlot: $timeSlot, address: $address, latitude: $latitude, '
      'longitude: $longitude, totalAmount: $totalAmount, tip: $tip, '
      'notes: $notes, createdAt: $createdAt, completedAt: $completedAt)';

  factory Booking.fromApiJson(Map<String, dynamic> json) {
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
      customerId: json['customer_id']?.toString() ?? '',
      washerId: json['assigned_employee_id']?.toString(),
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
      totalAmount: 0.0,
      notes: json['notes']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }
}
