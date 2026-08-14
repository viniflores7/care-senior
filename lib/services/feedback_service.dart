import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/feedback.dart';
import 'package:care_senior_study/data/repositories/feedback_repository.dart';

class FeedbackService {
  final _feedbackRepository = GetIt.I<FeedbackRepository>();

  Future<UserFeedback> submitFeedback({
    required String authorId,
    required String authorName,
    required String authorRole,
    required int rating,
    required String message,
  }) {
    return _feedbackRepository.submitFeedback(
      authorId: authorId,
      authorName: authorName,
      authorRole: authorRole,
      rating: rating,
      message: message,
    );
  }
}
