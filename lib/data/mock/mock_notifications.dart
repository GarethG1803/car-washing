import 'package:clean_ride/data/models/notification_item.dart';

class MockNotifications {
  static final List<NotificationItem> notifications = [
    NotificationItem(
      id: 'n1',
      title: 'Booking Confirmed',
      body: 'Your Premium Detail for tomorrow at 10:00 AM has been confirmed.',
      type: NotificationType.booking,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    NotificationItem(
      id: 'n2',
      title: 'Washer En Route',
      body: 'Marcus Rivera is on the way! ETA: 15 minutes.',
      type: NotificationType.booking,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationItem(
      id: 'n3',
      title: 'Payment Received',
      body: 'Payment of Rp 150.000 for Standard Wash has been processed.',
      type: NotificationType.payment,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationItem(
      id: 'n4',
      title: 'Summer Special!',
      body: 'Use code SUMMER20 to get 20% off your next wash. Limited time!',
      type: NotificationType.promotion,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    NotificationItem(
      id: 'n5',
      title: 'Rate Your Experience',
      body: 'How was your Standard Wash with James Wilson? Leave a review!',
      type: NotificationType.booking,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationItem(
      id: 'n6',
      title: 'Loyalty Points Earned',
      body: 'You earned 50 points for your recent booking. Total: 320 points.',
      type: NotificationType.system,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    NotificationItem(
      id: 'n7',
      title: 'App Update Available',
      body: 'CleanRide v2.0 is here with new features and improvements!',
      type: NotificationType.system,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NotificationItem(
      id: 'n8',
      title: 'Referral Bonus!',
      body: 'Your friend Emily just signed up! You earned Rp 150.000 credit.',
      type: NotificationType.payment,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}
