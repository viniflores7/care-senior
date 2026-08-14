import 'package:care_senior_study/injector/dependencies.dart';
import 'package:care_senior_study/injector/repositories.dart';
import 'package:care_senior_study/injector/services.dart';

class Injector {
  static void registerDependencies() {
    Repositories.registerRepositories();
    Dependencies.registerDependencies();
    Services.registerServices();
  }
}
