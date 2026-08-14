import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/repositories/activity_repository.dart';
import 'package:care_senior_study/data/repositories/auth_repository.dart';
import 'package:care_senior_study/data/repositories/clinic_repository.dart';
import 'package:care_senior_study/data/repositories/feedback_repository.dart';
import 'package:care_senior_study/data/repositories/medication_repository.dart';
import 'package:care_senior_study/data/repositories/notification_repository.dart';
import 'package:care_senior_study/data/repositories/resident_repository.dart';

class Repositories {
  static final getIt = GetIt.instance;

  static void registerRepositories() {
    if (!getIt.isRegistered<ClinicRepository>()) {
      getIt.registerLazySingleton<ClinicRepository>(MockClinicRepository.new);
    }

    if (!getIt.isRegistered<ResidentRepository>()) {
      getIt.registerLazySingleton<ResidentRepository>(
        MockResidentRepository.new,
      );
    }

    if (!getIt.isRegistered<ActivityRepository>()) {
      getIt.registerLazySingleton<ActivityRepository>(
        MockActivityRepository.new,
      );
    }

    if (!getIt.isRegistered<AuthRepository>()) {
      getIt.registerLazySingleton<AuthRepository>(MockAuthRepository.new);
    }

    if (!getIt.isRegistered<FeedbackRepository>()) {
      getIt.registerLazySingleton<FeedbackRepository>(
        MockFeedbackRepository.new,
      );
    }

    if (!getIt.isRegistered<NotificationRepository>()) {
      getIt.registerLazySingleton<NotificationRepository>(
        MockNotificationRepository.new,
      );
    }

    if (!getIt.isRegistered<MedicationRepository>()) {
      getIt.registerLazySingleton<MedicationRepository>(
        MockMedicationRepository.new,
      );
    }
  }
}
