import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppColor.primaryDark,
  foregroundColor: AppColor.white,
  disabledBackgroundColor: AppColor.primaryDark.withValues(alpha: 0.5),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);
