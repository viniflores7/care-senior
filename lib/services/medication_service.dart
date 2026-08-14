import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/repositories/medication_repository.dart';

class MedicationService {
  final _medicationRepository = GetIt.I<MedicationRepository>();

  Future<List<Medication>> getMedicationsByResidentId(String residentId) {
    return _medicationRepository.getMedicationsByResidentId(residentId);
  }

  Future<List<Medication>> getMedicationsByClinic(List<String> residentIds) {
    return _medicationRepository.getMedicationsByClinic(residentIds);
  }

  Future<Medication> addMedication({
    required String residentId,
    required String name,
    required String dosage,
    required String form,
    required String frequency,
    required DateTime startDate,
    String? instructions,
    String? prescribedBy,
  }) {
    return _medicationRepository.addMedication(
      residentId: residentId,
      name: name,
      dosage: dosage,
      form: form,
      frequency: frequency,
      startDate: startDate,
      instructions: instructions,
      prescribedBy: prescribedBy,
    );
  }
}
