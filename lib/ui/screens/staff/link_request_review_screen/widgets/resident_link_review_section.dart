import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

/// Perfil de cuidado de um idoso pendente de vínculo: dados já preenchidos
/// no autocadastro do responsável (somente leitura) + o quarto que a
/// clínica está atribuindo agora.
class ResidentLinkReviewSection extends StatelessWidget {
  const ResidentLinkReviewSection({
    super.key,
    required this.resident,
    required this.medications,
    required this.roomController,
  });

  final Resident resident;
  final List<Medication> medications;
  final TextEditingController roomController;

  @override
  Widget build(BuildContext context) {
    final hasProfileInfo =
        resident.healthNotes.isNotEmpty ||
        resident.mood != null ||
        resident.peculiarities != null ||
        resident.emergencyContactName != null ||
        resident.emergencyContactPhone != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 12,
          children: [
            AppAvatar(name: resident.name, photoPath: resident.photoPath),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resident.name, style: AppTextStyle.subtitleStyle),
                Text('${resident.age} anos', style: AppTextStyle.captionStyle),
              ],
            ),
          ],
        ),
        if (hasProfileInfo) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                if (resident.healthNotes.isNotEmpty)
                  Text(resident.healthNotes, style: AppTextStyle.bodyStyle),
                if (resident.mood != null)
                  Text(
                    'Humor: ${resident.mood}',
                    style: AppTextStyle.captionStyle,
                  ),
                if (resident.peculiarities != null)
                  Text(
                    'Peculiaridades: ${resident.peculiarities}',
                    style: AppTextStyle.captionStyle,
                  ),
                if (resident.emergencyContactName != null ||
                    resident.emergencyContactPhone != null)
                  Text(
                    'Contato de emergência: '
                    '${[resident.emergencyContactName, resident.emergencyContactPhone].whereType<String>().join(' · ')}',
                    style: AppTextStyle.captionStyle,
                  ),
              ],
            ),
          ),
        ],
        if (medications.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Medicamentos', style: AppTextStyle.captionStyle),
          const SizedBox(height: 8),
          for (final medication in medications)
            AppCard(
              title: '${medication.name} · ${medication.dosage}',
              subtitle: '${medication.form} · ${medication.frequency}',
            ).padding(bottom: 8),
        ],
        const SizedBox(height: 16),
        AppTextField(label: 'Quarto', controller: roomController),
      ],
    );
  }
}
