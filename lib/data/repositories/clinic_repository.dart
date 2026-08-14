import 'package:care_senior_study/data/mock/mock_data.dart';
import 'package:care_senior_study/data/models/clinic.dart';

abstract class ClinicRepository {
  Future<List<Clinic>> getAllClinics();

  Future<Clinic?> getClinicById(String id);
}

class MockClinicRepository implements ClinicRepository {
  static const _latency = Duration(milliseconds: 300);

  @override
  Future<List<Clinic>> getAllClinics() async {
    await Future.delayed(_latency);
    return MockData.clinics;
  }

  @override
  Future<Clinic?> getClinicById(String id) async {
    await Future.delayed(_latency);
    for (final clinic in MockData.clinics) {
      if (clinic.id == id) return clinic;
    }
    return null;
  }
}
