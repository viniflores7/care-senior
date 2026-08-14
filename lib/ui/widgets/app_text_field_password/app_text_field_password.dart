import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';

class AppTextFieldPassword extends StatefulWidget {
  const AppTextFieldPassword({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  State<AppTextFieldPassword> createState() => _AppTextFieldPasswordState();
}

class _AppTextFieldPasswordState extends State<AppTextFieldPassword> {
  final _focusNode = FocusNode();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  void _toggleObscureText() => setState(() => _obscureText = !_obscureText);

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = _focusNode.hasFocus;
    final iconColor = hasFocus
        ? AppColor.primary
        : AppColor.textDark.withValues(alpha: 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyle.captionStyle.copyWith(color: AppColor.textDark),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.curve,
          decoration: BoxDecoration(
            color: hasFocus ? AppColor.primarySoft : AppColor.greyLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasFocus ? AppColor.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            obscureText: _obscureText,
            obscuringCharacter: '•',
            style: AppTextStyle.bodyStyle,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                onPressed: _toggleObscureText,
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
