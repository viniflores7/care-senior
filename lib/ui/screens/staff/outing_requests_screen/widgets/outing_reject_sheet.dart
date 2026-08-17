import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

/// Folha exibida ao recusar uma solicitação de saída, pra capturar o
/// motivo — é o dado que o responsável vê explicando a recusa.
class OutingRejectSheet extends StatefulWidget {
  const OutingRejectSheet({super.key});

  @override
  State<OutingRejectSheet> createState() => _OutingRejectSheetState();
}

class _OutingRejectSheetState extends State<OutingRejectSheet> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _confirm() {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) return;
    Navigator.of(context).pop(reason);
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
            Text('Por que está recusando?', style: AppTextStyle.subtitleStyle),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Motivo (visível ao responsável)',
              controller: _reasonController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            AppButton(label: 'Confirmar recusa', onPressed: _confirm),
          ],
        ),
      ),
    );
  }
}
