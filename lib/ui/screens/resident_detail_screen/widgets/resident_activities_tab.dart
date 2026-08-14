import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/ui/screens/resident_detail_screen/widgets/activity_timeline.dart';
import 'package:care_senior_study/ui/widgets/activity_progress_summary/activity_progress_summary.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';

/// Aba "Agenda": resumo de progresso do dia, ação de agendar (equipe) e a
/// linha do tempo com todas as atividades do idoso.
class ResidentActivitiesTab extends StatelessWidget {
  const ResidentActivitiesTab({
    super.key,
    required this.activities,
    required this.residentId,
    required this.completedCount,
    required this.totalCount,
    required this.isStaff,
    required this.onScheduleActivity,
    required this.onView,
  });

  final List<Activity> activities;
  final String residentId;
  final int completedCount;
  final int totalCount;
  final bool isStaff;
  final VoidCallback onScheduleActivity;
  final void Function(Activity activity) onView;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ActivityProgressSummary(completed: completedCount, total: totalCount),
        const SizedBox(height: 16),
        if (isStaff)
          AppButton(
            label: 'Agendar atividade',
            type: ButtonType.outlined,
            icon: Icons.add,
            onPressed: onScheduleActivity,
          ).padding(bottom: 16),
        Expanded(
          child: ActivityTimeline(
            activities: activities,
            residentId: residentId,
            onView: onView,
          ),
        ),
      ],
    );
  }
}
