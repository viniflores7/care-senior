import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/app_notification.dart';
import 'package:care_senior_study/data/repositories/notification_repository.dart';

class NotificationService {
  final _notificationRepository = GetIt.I<NotificationRepository>();

  Future<List<AppNotification>> getNotifications({required String viewerRole}) {
    return _notificationRepository.getNotifications(viewerRole: viewerRole);
  }

  Future<void> markAsRead(String id) {
    return _notificationRepository.markAsRead(id);
  }
}
