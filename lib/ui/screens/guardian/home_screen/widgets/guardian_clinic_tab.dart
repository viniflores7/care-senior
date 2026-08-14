import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/mock_map_preview/mock_map_preview.dart';

/// Aba "Clínica" para quem já está vinculado: só as informações da(s)
/// clínica(s) do seu idoso — sem busca, sem lista de outras clínicas.
class GuardianClinicTab extends StatelessWidget {
  const GuardianClinicTab({super.key, required this.clinics});

  final List<Clinic> clinics;

  @override
  Widget build(BuildContext context) {
    if (clinics.isEmpty) {
      return Text(
        'Informações da clínica indisponíveis.',
        style: AppTextStyle.bodyStyle,
      ).center();
    }

    return ListView.separated(
      itemCount: clinics.length,
      separatorBuilder: (_, _) =>
          const Divider(color: AppColor.greyMedium, height: 32),
      itemBuilder: (context, index) => _ClinicInfo(clinic: clinics[index]),
    );
  }
}

class _ClinicInfo extends StatelessWidget {
  const _ClinicInfo({required this.clinic});

  final Clinic clinic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
      ],
    );
  }
}
