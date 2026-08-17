import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';

/// Campo de busca com ícone — mesmo visual do `AppTextField`, mas sem label
/// (usa hint) e com ícone de lupa, pra filtrar listas por nome.
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    this.hint = 'Buscar',
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = _focusNode.hasFocus;

    return AnimatedContainer(
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
        onChanged: widget.onChanged,
        style: AppTextStyle.bodyStyle,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: AppTextStyle.bodyStyle.copyWith(color: AppColor.textDark),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColor.primaryDark,
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
