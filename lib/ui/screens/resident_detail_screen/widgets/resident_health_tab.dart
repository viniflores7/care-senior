import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/data/models/health_record.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

/// Aba "Saúde": perfil de cuidado do idoso (saúde/humor/peculiaridades —
/// costuma já vir preenchido pelo responsável, antes mesmo do vínculo com a
/// clínica), medicamentos prescritos e histórico de sinais vitais.
class ResidentHealthTab extends StatelessWidget {
  const ResidentHealthTab({
    super.key,
    required this.resident,
    required this.medications,
    required this.records,
    required this.showAddButton,
    required this.onAddMedication,
    required this.onAdd,
  });

  final Resident? resident;
  final List<Medication> medications;
  final List<HealthRecord> records;
  final bool showAddButton;
  final VoidCallback onAddMedication;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM HH:mm');
    final activeMedications = medications.where((m) => m.active).toList();
    final resident = this.resident;
    final hasProfileInfo =
        resident != null &&
        (resident.healthNotes.isNotEmpty ||
            resident.mood != null ||
            resident.peculiarities != null);

    return ListView(
      children: [
        if (hasProfileInfo) ...[
          Text('Perfil do idoso', style: AppTextStyle.subtitleStyle),
          const SizedBox(height: 12),
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
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        Text('Medicamentos', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 12),
        if (activeMedications.isEmpty)
          Text(
            'Nenhum medicamento cadastrado ainda.',
            style: AppTextStyle.bodyStyle,
          )
        else
          ...activeMedications.map(
            (medication) => FadeSlideIn(
              child: AppCard(
                title: '${medication.name} · ${medication.dosage}',
                subtitle:
                    '${medication.form} · ${medication.frequency}'
                    '${medication.prescribedBy != null ? ' · ${medication.prescribedBy}' : ''}',
                child: medication.instructions != null
                    ? Text(
                        medication.instructions!,
                        style: AppTextStyle.captionStyle,
                      ).padding(top: 8)
                    : null,
              ).padding(bottom: 12),
            ),
          ),
        if (showAddButton)
          AppButton(
            label: 'Cadastrar medicamento',
            type: ButtonType.outlined,
            icon: Icons.add,
            onPressed: onAddMedication,
          ).padding(bottom: 24),
        Text('Sinais vitais e medições', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 12),
        if (showAddButton)
          AppButton(
            label: 'Registrar dado de saúde',
            type: ButtonType.outlined,
            icon: Icons.add,
            onPressed: onAdd,
          ).padding(bottom: 16),
        if (records.isEmpty)
          Text(
            'Nenhum dado de saúde registrado ainda.',
            style: AppTextStyle.bodyStyle,
          )
        else
          ...records.map(
            (record) => FadeSlideIn(
              child: AppCard(
                title: '${record.type}: ${record.value}',
                subtitle:
                    '${dateFormat.format(record.recordedAt)} · ${record.recordedBy}',
              ).padding(bottom: 12),
            ),
          ),
      ],
    );
  }
}
