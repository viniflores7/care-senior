import 'package:flutter/material.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/utils/navigator.dart';

class RoleSelectionScreenViewModel {
  void navigateToGuardianLogin(BuildContext context) {
    navigator(context).pushNamed(Routes.guardianLoginScreen);
  }

  void navigateToStaffLogin(BuildContext context) {
    navigator(context).pushNamed(Routes.staffLoginScreen);
  }
}
