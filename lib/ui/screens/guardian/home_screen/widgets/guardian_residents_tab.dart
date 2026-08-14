import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

/// Aba "Meus idosos": idosos vinculados ao responsável logado.
class GuardianResidentsTab extends StatelessWidget {
  const GuardianResidentsTab({
    super.key,
    required this.residents,
    required this.onView,
  });

  final List<Resident> residents;
  final void Function(String residentId) onView;

  @override
  Widget build(BuildContext context) {
    if (residents.isEmpty) {
      return Text(
        'Nenhum idoso vinculado ainda.',
        style: AppTextStyle.bodyStyle,
      ).center();
    }

    return ListView.separated(
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
