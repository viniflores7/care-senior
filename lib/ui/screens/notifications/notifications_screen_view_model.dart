import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/app_notification.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/routing/args/viewer_role.dart';
import 'package:care_senior_study/services/notification_service.dart';

/// Lê o papel do usuário direto do `AuthStore`, sem argumentos de rota —
/// mesmo padrão usado em `FeedbackScreenViewModel`.
class NotificationsScreenViewModel extends ChangeNotifier {
  final _authStore = GetIt.I<AuthStore>();
  final _notificationService = GetIt.I<NotificationService>();

  List<AppNotification> notifications = [];
  bool isLoading = true;

  String get _viewerRole =>
      _authStore.staff != null ? ViewerRole.staff : ViewerRole.guardian;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    notifications = await _notificationService.getNotifications(
      viewerRole: _viewerRole,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(AppNotification notification) async {
    if (notification.read) return;

    await _notificationService.markAsRead(notification.id);
    final index = notifications.indexWhere((n) => n.id == notification.id);
    if (index == -1) return;

    notifications[index] = notifications[index].copyWith(read: true);
    notifyListeners();
  }
}
