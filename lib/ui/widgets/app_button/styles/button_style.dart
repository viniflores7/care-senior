import 'package:flutter/material.dart';
import 'package:care_senior_study/ui/widgets/app_button/styles/outlined_button_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/styles/primary_button_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/styles/secondary_button_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/type/button_type.dart';

ButtonStyle getButtonStyle(ButtonType type) => switch (type) {
  ButtonType.primary => primaryButtonStyle,
  ButtonType.secondary => secondaryButtonStyle,
  ButtonType.outlined => outlinedButtonStyle,
};
