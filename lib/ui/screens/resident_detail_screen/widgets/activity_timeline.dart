import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/resident_detail_screen/widgets/activity_day_section.dart';

/// Agenda estilo Google Agenda: todas as atividades do idoso agrupadas por
/// dia, em ordem cronológica.
class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({
    super.key,
    required this.activities,
    required this.residentId,
    required this.onView,
  });

  final List<Activity> activities;
  final String residentId;
  final void Function(Activity activity) onView;

  Map<DateTime, List<Activity>> _groupByDay() {
    final sorted = [...activities]
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

    final groups = <DateTime, List<Activity>>{};
    for (final activity in sorted) {
      final scheduled = activity.scheduledTime;
      final day = DateTime(scheduled.year, scheduled.month, scheduled.day);
      groups.putIfAbsent(day, () => []).add(activity);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_note_outlined,
              size: 40,
              color: AppColor.primaryDark,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhuma atividade registrada ainda.',
              style: AppTextStyle.bodyStyle,
            ),
          ],
        ),
      );
    }

    final groups = _groupByDay();
    final days = groups.keys.toList();

    return ListView.separated(
      itemCount: days.length,
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final day = days[index];
        return ActivityDaySection(
          day: day,
          activities: groups[day]!,
          residentId: residentId,
          onView: onView,
        );
      },
    );
  }
}
