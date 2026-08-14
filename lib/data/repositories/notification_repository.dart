import 'package:care_senior_study/data/mock/mock_data.dart';
import 'package:care_senior_study/data/models/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications({required String viewerRole});

  Future<void> markAsRead(String id);
}

class MockNotificationRepository implements NotificationRepository {
  static const _latency = Duration(milliseconds: 300);

  final List<AppNotification> _notifications = List.of(MockData.notifications);

  @override
  Future<List<AppNotification>> getNotifications({
    required String viewerRole,
  }) async {
    await Future.delayed(_latency);

    final filtered = _notifications
        .where((n) => n.audience == null || n.audience == viewerRole)
        .toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notifications[index] = _notifications[index].copyWith(read: true);
  }
}
