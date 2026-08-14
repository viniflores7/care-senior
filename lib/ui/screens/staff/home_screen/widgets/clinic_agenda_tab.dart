import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/home_screen/widgets/clinic_activity_row.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

/// Aba "Agenda" da clínica: eventos de hoje e amanhã de todos os idosos,
/// com ação para agendar uma nova atividade vinculada a vários idosos.
class ClinicAgendaTab extends StatelessWidget {
  const ClinicAgendaTab({
    super.key,
    required this.todayActivities,
    required this.tomorrowActivities,
    required this.onScheduleActivity,
    required this.onView,
  });

  final List<Activity> todayActivities;
  final List<Activity> tomorrowActivities;
  final VoidCallback onScheduleActivity;
  final void Function(Activity activity) onView;

  @override
  Widget build(BuildContext context) {
    final hasActivities =
        todayActivities.isNotEmpty || tomorrowActivities.isNotEmpty;

    return ListView(
      children: [
        AppButton(
          label: 'Agendar atividade',
          type: ButtonType.outlined,
          icon: Icons.add,
          onPressed: onScheduleActivity,
        ).padding(bottom: 16),
        if (hasActivities) ...[
          if (todayActivities.isNotEmpty)
            _AgendaSection(
              label: 'Hoje',
              activities: todayActivities,
              onView: onView,
            ),
          if (todayActivities.isNotEmpty && tomorrowActivities.isNotEmpty)
            const SizedBox(height: 20),
          if (tomorrowActivities.isNotEmpty)
            _AgendaSection(
              label: 'Amanhã',
              activities: tomorrowActivities,
              onView: onView,
            ),
        ] else
          Text(
            'Nenhuma atividade agendada para hoje ou amanhã.',
            style: AppTextStyle.bodyStyle,
            textAlign: TextAlign.center,
          ).padding(top: 32),
      ],
    );
  }
}

class _AgendaSection extends StatelessWidget {
  const _AgendaSection({
    required this.label,
    required this.activities,
    required this.onView,
  });

  final String label;
  final List<Activity> activities;
  final void Function(Activity activity) onView;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.titleStyle),
        const Divider(color: AppColor.greyMedium),
        ...activities.map(
          (activity) => FadeSlideIn(
            child: ClinicActivityRow(
              activity: activity,
              onTap: () => onView(activity),
            ),
          ),
        ),
      ],
    );
  }
}
