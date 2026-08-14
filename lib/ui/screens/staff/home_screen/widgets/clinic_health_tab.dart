import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/data/models/health_record.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

/// Aba "Saúde" da clínica: medicamentos e registros de saúde de todos os
/// idosos, mais recentes primeiro. Adicionar um item pede primeiro qual
/// idoso, já que o dado em si é sempre por idoso.
class ClinicHealthTab extends StatelessWidget {
  const ClinicHealthTab({
    super.key,
    required this.medications,
    required this.records,
    required this.residents,
    required this.onAddMedication,
    required this.onAddRecord,
  });

  final List<Medication> medications;
  final List<HealthRecord> records;
  final List<Resident> residents;
  final void Function(String residentId) onAddMedication;
  final void Function(String residentId) onAddRecord;

  String _residentName(String residentId) {
    for (final resident in residents) {
      if (resident.id == residentId) return resident.name;
    }
    return 'Idoso não encontrado';
  }

  Future<void> _pickResident(
    BuildContext context,
    void Function(String residentId) onPicked,
  ) async {
    final residentId = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: residents
                .map(
                  (resident) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: AppAvatar(name: resident.name, radius: 18),
                    title: Text(resident.name),
                    subtitle: Text('Quarto ${resident.roomNumber}'),
                    onTap: () => Navigator.of(sheetContext).pop(resident.id),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
    if (residentId != null) onPicked(residentId);
  }

  @override
  Widget build(BuildContext context) {
    final activeMedications = medications.where((m) => m.active).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final sortedRecords = [...records]
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    final dateFormat = DateFormat('dd/MM HH:mm');

    return ListView(
      children: [
        Text('Medicamentos', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 12),
        AppButton(
          label: 'Cadastrar medicamento',
          type: ButtonType.outlined,
          icon: Icons.add,
          onPressed: residents.isEmpty
              ? null
              : () => _pickResident(context, onAddMedication),
        ).padding(bottom: 16),
        if (activeMedications.isEmpty)
          Text(
            'Nenhum medicamento cadastrado ainda.',
            style: AppTextStyle.bodyStyle,
          ).padding(bottom: 24)
        else
          ...activeMedications.map(
            (medication) => FadeSlideIn(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${_residentName(medication.residentId)} · ${medication.name}',
                ),
                subtitle: Text(
                  '${medication.dosage} · ${medication.form} · ${medication.frequency}',
                ),
              ),
            ),
          ),
        const Divider(color: AppColor.greyMedium),
        const SizedBox(height: 12),
        Text('Sinais vitais e medições', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 12),
        AppButton(
          label: 'Adicionar registro',
          type: ButtonType.outlined,
          icon: Icons.add,
          onPressed: residents.isEmpty
              ? null
              : () => _pickResident(context, onAddRecord),
        ).padding(bottom: 16),
        if (sortedRecords.isEmpty)
          Text('Nenhum registro de saúde ainda.', style: AppTextStyle.bodyStyle)
        else
          ...sortedRecords.map(
            (record) => FadeSlideIn(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${_residentName(record.residentId)} · ${record.type}',
                ),
                subtitle: Text(
                  '${record.value} · ${dateFormat.format(record.recordedAt)}',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
