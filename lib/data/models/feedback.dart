/// Nome `UserFeedback` (não `Feedback`) para não colidir com a classe
/// `Feedback` do próprio Flutter (`package:flutter/widgets.dart`).
class UserFeedback {
  const UserFeedback({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.rating,
    required this.message,
    required this.sentAt,
  });

  final String id;
  final String authorId;
  final String authorName;

  /// `ViewerRole.staff` ou `ViewerRole.guardian`.
  final String authorRole;

  /// Nota de 1 a 5.
  final int rating;
  final String message;
  final DateTime sentAt;
}
