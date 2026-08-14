import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

final ButtonStyle outlinedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.transparent,
  foregroundColor: AppColor.primaryDark,
  disabledForegroundColor: AppColor.primaryDark.withValues(alpha: 0.5),
  elevation: 0,
  side: const BorderSide(color: AppColor.primaryDark),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);
