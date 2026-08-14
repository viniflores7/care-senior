import 'package:get_it/get_it.dart';
import 'package:care_senior_study/services/activity_service.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/services/feedback_service.dart';
import 'package:care_senior_study/services/medication_service.dart';
import 'package:care_senior_study/services/notification_service.dart';
import 'package:care_senior_study/services/resident_service.dart';

class Services {
  static final getIt = GetIt.instance;

  static void registerServices() {
    if (!getIt.isRegistered<AuthService>()) {
      getIt.registerLazySingleton<AuthService>(AuthService.new);
    }

    if (!getIt.isRegistered<ResidentService>()) {
      getIt.registerLazySingleton<ResidentService>(ResidentService.new);
    }

    if (!getIt.isRegistered<ActivityService>()) {
      getIt.registerLazySingleton<ActivityService>(ActivityService.new);
    }

    if (!getIt.isRegistered<FeedbackService>()) {
      getIt.registerLazySingleton<FeedbackService>(FeedbackService.new);
    }

    if (!getIt.isRegistered<NotificationService>()) {
      getIt.registerLazySingleton<NotificationService>(NotificationService.new);
    }

    if (!getIt.isRegistered<MedicationService>()) {
      getIt.registerLazySingleton<MedicationService>(MedicationService.new);
    }
  }
}
