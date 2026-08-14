import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/styles/button_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/type/button_type.dart';

export 'package:care_senior_study/ui/widgets/app_button/type/button_type.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: getButtonStyle(type),
        child: AnimatedSwitcher(
          duration: AppMotion.fast,
          child: _ButtonContent(
            key: ValueKey(isLoading),
            label: label,
            icon: icon,
            isLoading: isLoading,
            type: type,
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    super.key,
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.type,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final ButtonType type;

  Color get _contentColor => switch (type) {
    ButtonType.primary => AppColor.white,
    ButtonType.secondary => AppColor.textDark,
    ButtonType.outlined => AppColor.primaryDark,
  };

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: _contentColor,
        ),
      );
    }

    final text = Text(
      label,
      style: AppTextStyle.buttonStyle.copyWith(color: _contentColor),
    );
    if (icon == null) return text;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: _contentColor),
        const SizedBox(width: 8),
        text,
      ],
    );
  }
}
