import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clean_ride/core/network/api_client.dart';

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String? body;
  final String? orderId;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    this.orderId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'info',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString(),
      orderId: json['order_id']?.toString(),
      isRead: json['read_at'] != null,
      createdAt: json['created_at'] != null
          ? (DateTime.tryParse(json['created_at'].toString())?.toLocal() ??
              DateTime.now())
          : DateTime.now(),
    );
  }
}

/// Fetches notifications + auto-polls every 30s while any listener is active.
/// Authentication-gated: refreshes when the token changes (login/logout).
final notificationsProvider =
    StreamProvider<List<AppNotification>>((ref) async* {
  ref.watch(tokenProvider);
  final dio = ref.read(apiClientProvider);
  var disposed = false;
  ref.onDispose(() => disposed = true);

  Future<List<AppNotification>> fetchOnce() async {
    if (ref.read(tokenProvider) == null) return const [];
    try {
      final response = await dio.get('/notifications');
      if (response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((j) => AppNotification.fromJson(j as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  yield await fetchOnce();
  while (!disposed) {
    await Future<void>.delayed(const Duration(seconds: 30));
    if (disposed) break;
    yield await fetchOnce();
  }
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final list = ref.watch(notificationsProvider).valueOrNull ?? const [];
  return list.where((n) => !n.isRead).length;
});

/// Mark one or all notifications as read on the server. Returns null on success.
final notificationActionsProvider = Provider((ref) => _NotificationActions(ref));

class _NotificationActions {
  final Ref _ref;
  _NotificationActions(this._ref);

  Future<void> markRead(String id) async {
    try {
      final dio = _ref.read(apiClientProvider);
      await dio.post('/notifications/$id/read');
      _ref.invalidate(notificationsProvider);
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      final dio = _ref.read(apiClientProvider);
      await dio.post('/notifications/read-all');
      _ref.invalidate(notificationsProvider);
    } catch (_) {}
  }
}
