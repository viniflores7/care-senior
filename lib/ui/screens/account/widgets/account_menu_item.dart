import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';

/// Uma linha do menu de conta: ícone num círculo colorido, rótulo e chevron.
class AccountMenuItem extends StatelessWidget {
  const AccountMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tintColor = color ?? AppColor.primaryDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.greyMedium),
          ),
          child: Row(
            spacing: 12,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: tintColor.withValues(alpha: 0.12),
                child: Icon(icon, color: tintColor, size: 20),
              ),
              Text(
                label,
                style: AppTextStyle.subtitleStyle.copyWith(color: tintColor),
              ).expanded(),
              Icon(Icons.chevron_right, color: AppColor.greyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
