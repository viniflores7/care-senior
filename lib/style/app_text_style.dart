import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:care_senior_study/style/app_color.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle get titleStyle => GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColor.textDark,
  );

  static TextStyle get subtitleStyle => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.textDark,
  );

  static TextStyle get bodyStyle => GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.textDark,
  );

  static TextStyle get captionStyle => GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColor.primaryDark,
  );

  static TextStyle get buttonStyle => GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
  );
}
