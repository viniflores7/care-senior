import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_star_rating/app_star_rating.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

/// Folha exibida ao concluir uma atividade — captura a nota e o comentário
/// que ficam visíveis ao responsável (sem identificar quem preencheu).
class ActivityOutcomeSheet extends StatefulWidget {
  const ActivityOutcomeSheet({
    super.key,
    this.title = 'Como foi para o idoso?',
  });

  final String title;

  @override
  State<ActivityOutcomeSheet> createState() => _ActivityOutcomeSheetState();
}

class _ActivityOutcomeSheetState extends State<ActivityOutcomeSheet> {
  int _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _confirm() {
    final comment = _commentController.text.trim();
    Navigator.of(context).pop((_rating, comment.isEmpty ? null : comment));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: AppTextStyle.subtitleStyle),
            const SizedBox(height: 16),
            AppStarRating(
              value: _rating,
              onChanged: (value) => setState(() => _rating = value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Comentário (opcional)',
              controller: _commentController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            AppButton(label: 'Confirmar', onPressed: _confirm),
          ],
        ),
      ),
    );
  }
}
