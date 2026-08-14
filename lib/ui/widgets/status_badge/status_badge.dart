import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/activity_status.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  Color get _color => switch (status) {
    ActivityStatus.completed => AppColor.success,
    ActivityStatus.late => AppColor.danger,
    ActivityStatus.inProgress => AppColor.primary,
    ActivityStatus.cancelled || ActivityStatus.skipped => AppColor.textDark,
    _ => AppColor.warning,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedDefaultTextStyle(
        duration: AppMotion.fast,
        curve: AppMotion.curve,
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        child: Text(status),
      ),
    );
  }
}
