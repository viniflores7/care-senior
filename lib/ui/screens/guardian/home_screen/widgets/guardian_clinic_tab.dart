import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/mock_map_preview/mock_map_preview.dart';

/// Aba "Clínica" para quem já está vinculado: só as informações da(s)
/// clínica(s) do seu idoso — sem busca, sem lista de outras clínicas. Se o
/// responsável tem idosos em mais de uma clínica, cada bloco mostra quais
/// idosos estão ali para não misturar as informações.
class GuardianClinicTab extends StatelessWidget {
  const GuardianClinicTab({
    super.key,
    required this.clinics,
    required this.residents,
  });

  final List<Clinic> clinics;
  final List<Resident> residents;

  @override
  Widget build(BuildContext context) {
    if (clinics.isEmpty) {
      return Text(
        'Informações da clínica indisponíveis.',
        style: AppTextStyle.bodyStyle,
      ).center();
    }

    final showResidentNames = clinics.length > 1;

    return ListView.separated(
      itemCount: clinics.length,
      separatorBuilder: (_, _) =>
          const Divider(color: AppColor.greyMedium, height: 32),
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        final clinicResidents = residents
            .where((resident) => resident.clinicId == clinic.id)
            .toList();
        return _ClinicInfo(
          clinic: clinic,
          residentNames: showResidentNames
              ? clinicResidents.map((r) => r.name).toList()
              : const [],
        );
      },
    );
  }
}

class _ClinicInfo extends StatelessWidget {
  const _ClinicInfo({required this.clinic, required this.residentNames});

  final Clinic clinic;
  final List<String> residentNames;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(clinic.name, style: AppTextStyle.titleStyle),
        if (residentNames.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Idoso(s): ${residentNames.join(', ')}',
            style: AppTextStyle.captionStyle,
          ),
        ],
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
