import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:care_senior_study/style/app_color.dart';

class CareSeniorTheme {
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColor.primary,
    scaffoldBackgroundColor: AppColor.background,
    textTheme: GoogleFonts.nunitoTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.primaryDark,
      foregroundColor: AppColor.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.nunito(
        color: AppColor.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
