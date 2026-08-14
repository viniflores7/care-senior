import 'package:flutter/material.dart';
import 'package:care_senior_study/injector/injector.dart';
import 'package:care_senior_study/routing/app_router.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/style/care_senior_theme.dart';

void main() {
  Injector.registerDependencies();
  runApp(const CareSeniorApp());
}

class CareSeniorApp extends StatelessWidget {
  const CareSeniorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care Senior',
      debugShowCheckedModeBanner: false,
      theme: CareSeniorTheme.themeData,
      initialRoute: Routes.roleSelectionScreen,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
