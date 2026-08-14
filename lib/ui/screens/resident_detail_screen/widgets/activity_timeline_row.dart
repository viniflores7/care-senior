import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/data/models/activity_status.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/activity_category_icon/activity_category_icon.dart';
import 'package:care_senior_study/ui/widgets/status_badge/status_badge.dart';

/// Uma linha da agenda: horário à esquerda, ícone/título/detalhe no meio,
/// status à direita — estilo Google Agenda.
class ActivityTimelineRow extends StatelessWidget {
  const ActivityTimelineRow({
    super.key,
    required this.activity,
    required this.residentId,
    required this.onTap,
  });

  final Activity activity;
  final String residentId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status =
        activity.participantFor(residentId)?.status ?? ActivityStatus.pending;
    final time = DateFormat('HH:mm').format(activity.scheduledTime);
    final detail = activity.detail;
    final subtitle = detail != null && detail.isNotEmpty
        ? '${activity.type} · $detail'
        : activity.type;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 56,
              child: Text('${time}h', style: AppTextStyle.captionStyle),
            ),
            Container(width: 2, height: 36, color: AppColor.greyMedium),
            const SizedBox(width: 12),
            ActivityCategoryIcon(
              type: activity.type,
              color: AppColor.primaryDark,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.title, style: AppTextStyle.subtitleStyle),
                  Text(subtitle, style: AppTextStyle.captionStyle),
                ],
              ),
            ),
            StatusBadge(status: status),
          ],
        ),
      ),
    );
  }
}
