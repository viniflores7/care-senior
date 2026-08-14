import 'package:care_senior_study/data/models/feedback.dart';

abstract class FeedbackRepository {
  Future<UserFeedback> submitFeedback({
    required String authorId,
    required String authorName,
    required String authorRole,
    required int rating,
    required String message,
  });
}

class MockFeedbackRepository implements FeedbackRepository {
  static const _latency = Duration(milliseconds: 300);

  final List<UserFeedback> _feedbacks = [];

  @override
  Future<UserFeedback> submitFeedback({
    required String authorId,
    required String authorName,
    required String authorRole,
    required int rating,
    required String message,
  }) async {
    await Future.delayed(_latency);
    final feedback = UserFeedback(
      id: 'feedback-${_feedbacks.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      authorId: authorId,
      authorName: authorName,
      authorRole: authorRole,
      rating: rating,
      message: message,
      sentAt: DateTime.now(),
    );
    _feedbacks.add(feedback);
    return feedback;
  }
}
