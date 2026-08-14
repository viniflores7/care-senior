import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppColor.primary.withValues(alpha: 0.6),
  foregroundColor: AppColor.textDark,
  disabledBackgroundColor: AppColor.primary.withValues(alpha: 0.5),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);
