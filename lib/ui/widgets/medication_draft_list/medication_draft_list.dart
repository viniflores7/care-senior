import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/medication_draft.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

/// Lista dos medicamentos já adicionados (mas ainda não persistidos)
/// durante um cadastro de idoso, com opção de remover cada um.
class MedicationDraftList extends StatelessWidget {
  const MedicationDraftList({
    super.key,
    required this.drafts,
    required this.onRemove,
  });

  final List<MedicationDraft> drafts;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    if (drafts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < drafts.length; i++)
          FadeSlideIn(
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.greyLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${drafts[i].name} · ${drafts[i].dosage}',
                          style: AppTextStyle.subtitleStyle,
                        ),
                        Text(
                          '${drafts[i].form} · ${drafts[i].frequency}',
                          style: AppTextStyle.captionStyle,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColor.danger),
                    onPressed: () => onRemove(i),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
