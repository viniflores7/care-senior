import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/mock_map_preview/mock_map_preview.dart';

/// Aba "Clínica": dados de contato, horário de funcionamento, atividades
/// oferecidas e responsável técnico da clínica do colaborador.
class ClinicInfoTab extends StatelessWidget {
  const ClinicInfoTab({
    super.key,
    required this.clinic,
    required this.onAddGuardian,
  });

  final Clinic? clinic;
  final VoidCallback onAddGuardian;

  @override
  Widget build(BuildContext context) {
    final clinic = this.clinic;
    if (clinic == null) {
      return Text(
        'Informações da clínica indisponíveis.',
        style: AppTextStyle.bodyStyle,
      ).center();
    }

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        Text(clinic.name, style: AppTextStyle.titleStyle),
        const SizedBox(height: 8),
        Text(clinic.address, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 4),
        Text(clinic.phone, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 4),
        Text(clinic.operatingHours, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 16),
        MockMapPreview(address: clinic.address),
        const SizedBox(height: 24),
        Text('Atividades oferecidas', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: clinic.activities
              .map((activity) => Chip(label: Text(activity)))
              .toList(),
        ),
        const SizedBox(height: 24),
        Text('Responsável', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 8),
        Text(clinic.responsiblePeople, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 24),
        AppButton(
          label: 'Adicionar responsável',
          type: ButtonType.outlined,
          icon: Icons.person_add_outlined,
          onPressed: onAddGuardian,
        ),
      ],
    );
  }
}
