import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/resident_detail_screen/widgets/activity_timeline_row.dart';

const _monthNames = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

/// Um dia da agenda: cabeçalho "Dia D" + mês, seguido das atividades
/// daquele dia (já ordenadas por horário).
class ActivityDaySection extends StatelessWidget {
  const ActivityDaySection({
    super.key,
    required this.day,
    required this.activities,
    required this.residentId,
    required this.onView,
  });

  final DateTime day;
  final List<Activity> activities;
  final String residentId;
  final void Function(Activity activity) onView;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('Dia ${day.day}', style: AppTextStyle.titleStyle),
            const SizedBox(width: 8),
            Text(
              _monthNames[day.month - 1],
              style: AppTextStyle.bodyStyle.copyWith(
                color: AppColor.primaryDark,
              ),
            ),
          ],
        ),
        const Divider(color: AppColor.greyMedium),
        ...activities.map(
          (activity) => ActivityTimelineRow(
            activity: activity,
            residentId: residentId,
            onTap: () => onView(activity),
          ),
        ),
      ],
    );
  }
}
