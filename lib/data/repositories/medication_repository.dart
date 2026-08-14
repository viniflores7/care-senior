import 'package:care_senior_study/data/mock/mock_data.dart';
import 'package:care_senior_study/data/models/medication.dart';

abstract class MedicationRepository {
  Future<List<Medication>> getMedicationsByResidentId(String residentId);

  Future<List<Medication>> getMedicationsByClinic(List<String> residentIds);

  Future<Medication> addMedication({
    required String residentId,
    required String name,
    required String dosage,
    required String form,
    required String frequency,
    required DateTime startDate,
    String? instructions,
    String? prescribedBy,
  });
}

class MockMedicationRepository implements MedicationRepository {
  static const _latency = Duration(milliseconds: 300);

  final List<Medication> _medications = List.of(MockData.medications);

  @override
  Future<List<Medication>> getMedicationsByResidentId(String residentId) async {
    await Future.delayed(_latency);
    return _medications.where((m) => m.residentId == residentId).toList();
  }

  @override
  Future<List<Medication>> getMedicationsByClinic(
    List<String> residentIds,
  ) async {
    await Future.delayed(_latency);
    return _medications
        .where((m) => residentIds.contains(m.residentId))
        .toList();
  }

  @override
  Future<Medication> addMedication({
    required String residentId,
    required String name,
    required String dosage,
    required String form,
    required String frequency,
    required DateTime startDate,
    String? instructions,
    String? prescribedBy,
  }) async {
    await Future.delayed(_latency);
    final medication = Medication(
      id: 'medication-${_medications.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      residentId: residentId,
      name: name,
      dosage: dosage,
      form: form,
      frequency: frequency,
      startDate: startDate,
      instructions: instructions,
      prescribedBy: prescribedBy,
    );
    _medications.add(medication);
    return medication;
  }
}
