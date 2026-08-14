import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/routing/args/viewer_role.dart';
import 'package:care_senior_study/services/feedback_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

/// Tela de feedback (RF-009) — disponível tanto para colaborador quanto para
/// responsável. Lê o autor direto do `AuthStore`, sem argumentos de rota.
class FeedbackScreenViewModel extends ChangeNotifier {
  final _authStore = GetIt.I<AuthStore>();
  final _feedbackService = GetIt.I<FeedbackService>();

  final messageController = TextEditingController();

  int rating = 5;
  bool isSaving = false;
  String? errorMessage;

  void setRating(int value) {
    rating = value;
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    final message = messageController.text.trim();
    if (message.isEmpty) {
      errorMessage = 'Escreva uma mensagem antes de enviar.';
      notifyListeners();
      return;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    final staff = _authStore.staff;
    final guardian = _authStore.guardian;

    await _feedbackService.submitFeedback(
      authorId: staff?.id ?? guardian?.id ?? '',
      authorName: staff?.name ?? guardian?.name ?? '',
      authorRole: staff != null ? ViewerRole.staff : ViewerRole.guardian,
      rating: rating,
      message: message,
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
