import 'package:care_senior_study/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';

class AppBasePage extends StatelessWidget {
  const AppBasePage({
    super.key,
    this.title,
    required this.body,
    this.showAppBar = true,
    this.actions,
    this.bottom,
    this.customAppBar,
    this.bottomNavigationBar,
  });

  final String? title;
  final Widget body;
  final bool showAppBar;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  final PreferredSizeWidget? customAppBar;

  /// Barra de navegação inferior da tela (ex.: `NavigationBar`). O
  /// `Scaffold`/o próprio widget já cuidam da área segura debaixo (gestos,
  /// home indicator) — não precisa de `SafeArea` manual aqui.
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar:
          customAppBar ??
          (showAppBar
              ? AppBar(
                  title: Text(title ?? ''),
                  centerTitle: true,
                  actions: actions,
                  bottom: bottom,
                )
              : null),
      body: SafeArea(child: body.padding(all: 16)),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
