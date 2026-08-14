import 'package:get_it/get_it.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';

class Dependencies {
  static final getIt = GetIt.instance;

  static void registerDependencies() {
    if (!getIt.isRegistered<AuthStore>()) {
      getIt.registerLazySingleton<AuthStore>(AuthStore.new);
    }
  }
}
