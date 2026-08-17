import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

/// Aba "Meus idosos": idosos vinculados ao responsável logado. Quando os
/// idosos estão em mais de uma clínica, agrupa por clínica para deixar
/// claro onde cada um está.
class GuardianResidentsTab extends StatelessWidget {
  const GuardianResidentsTab({
    super.key,
    required this.residents,
    required this.clinics,
    required this.onView,
  });

  final List<Resident> residents;

  /// Clínicas dos idosos vinculados — usada só para os nomes das seções
  /// quando há mais de uma clínica envolvida.
  final List<Clinic> clinics;
  final void Function(String residentId) onView;

  @override
  Widget build(BuildContext context) {
    if (residents.isEmpty) {
      return Text(
        'Nenhum idoso vinculado ainda.',
        style: AppTextStyle.bodyStyle,
      ).center();
    }

    final clinicIds = residents.map((r) => r.clinicId).toSet();
    if (clinicIds.length <= 1) {
      return _ResidentList(residents: residents, onView: onView);
    }

    final clinicNameById = {for (final clinic in clinics) clinic.id: clinic};
    final residentsByClinicId = <String, List<Resident>>{};
    for (final resident in residents) {
      final clinicId = resident.clinicId;
      if (clinicId == null) continue;
      (residentsByClinicId[clinicId] ??= []).add(resident);
    }

    return ListView(
      children: [
        for (final entry in residentsByClinicId.entries) ...[
          Text(
            clinicNameById[entry.key]?.name ?? 'Clínica',
            style: AppTextStyle.subtitleStyle,
          ).padding(bottom: 12),
          _ResidentList(
            residents: entry.value,
            onView: onView,
            shrinkWrap: true,
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _ResidentList extends StatelessWidget {
  const _ResidentList({
    required this.residents,
    required this.onView,
    this.shrinkWrap = false,
  });

  final List<Resident> residents;
  final void Function(String residentId) onView;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: residents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final resident = residents[index];
        return FadeSlideIn(
          child: AppCard(
            leading: AppAvatar(
              name: resident.name,
              photoPath: resident.photoPath,
            ),
            title: resident.name,
            subtitle: resident.roomNumber != null
                ? 'Quarto ${resident.roomNumber} · ${resident.age} anos'
                : '${resident.age} anos',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onView(resident.id),
          ),
        );
      },
    );
  }
}
