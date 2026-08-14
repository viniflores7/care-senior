import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

/// Folha exibida ao "pular" uma atividade, pra capturar o motivo — é o dado
/// que garante ao responsável saber por que algo não foi feito.
class SkipReasonSheet extends StatefulWidget {
  const SkipReasonSheet({super.key});

  @override
  State<SkipReasonSheet> createState() => _SkipReasonSheetState();
}

class _SkipReasonSheetState extends State<SkipReasonSheet> {
  static const _quickReasons = ['Recusou', 'Não estava na clínica', 'Outro'];

  String? _selected;
  final _otherController = TextEditingController();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _confirm() {
    final selected = _selected;
    if (selected == null) return;

    final reason = selected == 'Outro'
        ? 'Outro: ${_otherController.text.trim()}'
        : selected;
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
            Text(
              'Por que não foi cumprida?',
              style: AppTextStyle.subtitleStyle,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickReasons
                  .map(
                    (reason) => ChoiceChip(
                      label: Text(reason),
                      selected: _selected == reason,
                      selectedColor: AppColor.primary,
                      labelStyle: TextStyle(
                        color: _selected == reason
                            ? AppColor.white
                            : AppColor.textDark,
                      ),
                      onSelected: (_) => setState(() => _selected = reason),
                    ),
                  )
                  .toList(),
            ),
            if (_selected == 'Outro') ...[
              const SizedBox(height: 12),
              AppTextField(label: 'Motivo', controller: _otherController),
            ],
            const SizedBox(height: 20),
            AppButton(label: 'Confirmar', onPressed: _confirm),
          ],
        ),
      ),
    );
  }
}
