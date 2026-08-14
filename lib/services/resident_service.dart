import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/data/repositories/clinic_repository.dart';
import 'package:care_senior_study/data/repositories/resident_repository.dart';

class ResidentService {
  final _residentRepository = GetIt.I<ResidentRepository>();
  final _clinicRepository = GetIt.I<ClinicRepository>();

  Future<List<Resident>> getResidentsForGuardian(List<String> residentIds) {
    return _residentRepository.getResidentsByIds(residentIds);
  }

  Future<List<Clinic>> getAllClinics() {
    return _clinicRepository.getAllClinics();
  }

  Future<List<Resident>> getResidentsForClinic(String clinicId) {
    return _residentRepository.getResidentsByClinicId(clinicId);
  }

  Future<Resident?> getResidentById(String id) {
    return _residentRepository.getResidentById(id);
  }

  Future<Resident> updateResident({
    required String id,
    String? name,
    int? age,
    String? healthNotes,
    String? mood,
    String? peculiarities,
    String? photoPath,
  }) {
    return _residentRepository.updateResident(
      id: id,
      name: name,
      age: age,
      healthNotes: healthNotes,
      mood: mood,
      peculiarities: peculiarities,
      photoPath: photoPath,
    );
  }

  Future<Clinic?> getClinicById(String id) {
    return _clinicRepository.getClinicById(id);
  }
}
