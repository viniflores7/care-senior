import 'package:flutter/material.dart';
import 'package:care_senior_study/routing/args/activity_detail_screen_arguments.dart';
import 'package:care_senior_study/routing/args/edit_resident_screen_arguments.dart';
import 'package:care_senior_study/routing/args/health_record_register_screen_arguments.dart';
import 'package:care_senior_study/routing/args/medication_register_screen_arguments.dart';
import 'package:care_senior_study/routing/args/resident_detail_screen_arguments.dart';
import 'package:care_senior_study/routing/args/schedule_activity_screen_arguments.dart';
import 'package:care_senior_study/routing/page_route/slide_route.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/ui/screens/account/about_screen/about_screen.dart';
import 'package:care_senior_study/ui/screens/account/account_security_screen/account_security_screen.dart';
import 'package:care_senior_study/ui/screens/account/edit_resident_screen/edit_resident_screen.dart';
import 'package:care_senior_study/ui/screens/account/feedback_screen/feedback_screen.dart';
import 'package:care_senior_study/ui/screens/account/help_support_screen/help_support_screen.dart';
import 'package:care_senior_study/ui/screens/account/notification_settings_screen/notification_settings_screen.dart';
import 'package:care_senior_study/ui/screens/activity_detail_screen/activity_detail_screen.dart';
import 'package:care_senior_study/ui/screens/app_intro_screen/app_intro_screen.dart';
import 'package:care_senior_study/ui/screens/guardian/home_screen/guardian_home_screen.dart';
import 'package:care_senior_study/ui/screens/guardian/login_screen/guardian_login_screen.dart';
import 'package:care_senior_study/ui/screens/guardian/register_screen/guardian_register_screen.dart';
import 'package:care_senior_study/ui/screens/notifications/notifications_screen.dart';
import 'package:care_senior_study/ui/screens/resident_detail_screen/resident_detail_screen.dart';
import 'package:care_senior_study/ui/screens/role_selection_screen/role_selection_screen.dart';
import 'package:care_senior_study/ui/screens/staff/add_guardian_screen/add_guardian_screen.dart';
import 'package:care_senior_study/ui/screens/staff/health_record_register_screen/health_record_register_screen.dart';
import 'package:care_senior_study/ui/screens/staff/home_screen/staff_home_screen.dart';
import 'package:care_senior_study/ui/screens/staff/login_screen/staff_login_screen.dart';
import 'package:care_senior_study/ui/screens/staff/medication_register_screen/medication_register_screen.dart';
import 'package:care_senior_study/ui/screens/staff/schedule_activity_screen/schedule_activity_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.roleSelectionScreen:
        return SlideRoute(
          settings: settings,
          page: const RoleSelectionScreen(),
        );

      case Routes.guardianLoginScreen:
        return SlideRoute(
          settings: settings,
          page: const GuardianLoginScreen(),
        );

      case Routes.appIntroScreen:
        return SlideRoute(settings: settings, page: const AppIntroScreen());

      case Routes.guardianRegisterScreen:
        return SlideRoute(
          settings: settings,
          page: const GuardianRegisterScreen(),
        );

      case Routes.guardianHomeScreen:
        return SlideRoute(settings: settings, page: const GuardianHomeScreen());

      case Routes.staffLoginScreen:
        return SlideRoute(settings: settings, page: const StaffLoginScreen());

      case Routes.staffHomeScreen:
        return SlideRoute(settings: settings, page: const StaffHomeScreen());

      case Routes.staffAddGuardianScreen:
        return SlideRoute(settings: settings, page: const AddGuardianScreen());

      case Routes.staffScheduleActivityScreen:
        if (args is ScheduleActivityScreenArguments) {
          return SlideRoute(
            settings: settings,
            page: ScheduleActivityScreen(args: args),
          );
        }
        return _errorRoute(settings);

      case Routes.residentDetailScreen:
        if (args is ResidentDetailScreenArguments) {
          return SlideRoute(
            settings: settings,
            page: ResidentDetailScreen(args: args),
          );
        }
        return _errorRoute(settings);

      case Routes.notificationsScreen:
        return SlideRoute(
          settings: settings,
          page: const NotificationsScreen(),
        );

      case Routes.activityDetailScreen:
        if (args is ActivityDetailScreenArguments) {
          return SlideRoute(
            settings: settings,
            page: ActivityDetailScreen(args: args),
          );
        }
        return _errorRoute(settings);

      case Routes.healthRecordRegisterScreen:
        if (args is HealthRecordRegisterScreenArguments) {
          return SlideRoute(
            settings: settings,
            page: HealthRecordRegisterScreen(args: args),
          );
        }
        return _errorRoute(settings);

      case Routes.medicationRegisterScreen:
        if (args is MedicationRegisterScreenArguments) {
          return SlideRoute(
            settings: settings,
            page: MedicationRegisterScreen(args: args),
          );
        }
        return _errorRoute(settings);

      case Routes.accountSecurityScreen:
        return SlideRoute(
          settings: settings,
          page: const AccountSecurityScreen(),
        );

      case Routes.editResidentScreen:
        if (args is EditResidentScreenArguments) {
          return SlideRoute(
            settings: settings,
            page: EditResidentScreen(args: args),
          );
        }
        return _errorRoute(settings);

      case Routes.notificationSettingsScreen:
        return SlideRoute(
          settings: settings,
          page: const NotificationSettingsScreen(),
        );

      case Routes.helpSupportScreen:
        return SlideRoute(settings: settings, page: const HelpSupportScreen());

      case Routes.aboutScreen:
        return SlideRoute(settings: settings, page: const AboutScreen());

      case Routes.feedbackScreen:
        return SlideRoute(settings: settings, page: const FeedbackScreen());

      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return SlideRoute(
      settings: settings,
      page: const Scaffold(body: Center(child: Text('Rota não encontrada'))),
    );
  }
}
