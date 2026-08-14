import 'package:care_senior_study/data/models/notification_type.dart';

/// Nome `AppNotification` (não `Notification`) para não colidir com a classe
/// `Notification` do próprio Flutter (`package:flutter/widgets.dart`).
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.read = false,

    /// `ViewerRole.staff`, `ViewerRole.guardian` ou `null` para ambos.
    this.audience,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool read;
  final String? audience;

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      createdAt: createdAt,
      read: read ?? this.read,
      audience: audience,
    );
  }
}
