import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/activity_category_icon/activity_category_icon.dart';

/// Uma linha da agenda da clínica: horário, tipo/título e um resumo de
/// quantos participantes já foram registrados como presentes.
class ClinicActivityRow extends StatelessWidget {
  const ClinicActivityRow({
    super.key,
    required this.activity,
    required this.onTap,
  });

  final Activity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(activity.scheduledTime);
    final detail = activity.detail;
    final subtitle = detail != null && detail.isNotEmpty
        ? '${activity.type} · $detail'
        : activity.type;
    final completed = activity.completedCount;
    final total = activity.totalCount;
    final allDone = total > 0 && completed == total;
    final badgeColor = allDone ? AppColor.success : AppColor.warning;

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$completed/$total',
                style: TextStyle(
                  color: badgeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
