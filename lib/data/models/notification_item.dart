import 'package:flutter/foundation.dart';

enum NotificationType { booking, payment, promotion, system }

@immutable
class NotificationItem {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          type == other.type &&
          isRead == other.isRead &&
          createdAt == other.createdAt &&
          mapEquals(data, other.data);

  @override
  int get hashCode => Object.hash(
        id,
        title,
        body,
        type,
        isRead,
        createdAt,
        data != null ? Object.hashAll(data!.entries) : null,
      );

  @override
  String toString() =>
      'NotificationItem(id: $id, title: $title, body: $body, '
      'type: $type, isRead: $isRead, createdAt: $createdAt, data: $data)';
}
