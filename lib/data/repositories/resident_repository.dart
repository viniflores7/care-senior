import 'package:care_senior_study/data/mock/mock_data.dart';
import 'package:care_senior_study/data/models/resident.dart';

abstract class ResidentRepository {
  Future<Resident?> getResidentById(String id);

  Future<List<Resident>> getResidentsByIds(List<String> ids);

  Future<List<Resident>> getResidentsByClinicId(String clinicId);

  /// [clinicId]/[roomNumber] ficam nulos quando é um responsável se
  /// cadastrando sozinho, ainda sem clínica vinculada.
  Future<Resident> createResident({
    required String name,
    required int age,
    String? clinicId,
    String? roomNumber,
    String? healthNotes,
    String? mood,
    String? peculiarities,
    String? photoPath,
    String? emergencyContactName,
    String? emergencyContactPhone,
  });

  /// Campos não informados (omitidos) mantêm o valor atual; passar `null`
  /// explicitamente limpa o campo — ver `Resident.unset`. Isso permite que
  /// atualizações parciais (ex.: `linkResidentToClinic`, só mexendo em
  /// `clinicId`/`roomNumber`) e atualizações de formulário completo (ex.:
  /// `EditResidentScreen`, que pode limpar `peculiarities`) usem o mesmo
  /// método sem se atrapalharem.
  Future<Resident> updateResident({
    required String id,
    Object? name = Resident.unset,
    Object? age = Resident.unset,
    Object? healthNotes = Resident.unset,
    Object? mood = Resident.unset,
    Object? peculiarities = Resident.unset,
    Object? photoPath = Resident.unset,
    Object? clinicId = Resident.unset,
    Object? roomNumber = Resident.unset,
    Object? emergencyContactName = Resident.unset,
    Object? emergencyContactPhone = Resident.unset,
  });

  /// Desvincula o idoso da clínica atual (alta, transferência ou correção
  /// de cadastro) — volta pro mesmo estado de antes de qualquer vínculo.
  Future<Resident> dischargeResident(String id);
}

class MockResidentRepository implements ResidentRepository {
  static const _latency = Duration(milliseconds: 300);

  @override
  Future<Resident?> getResidentById(String id) async {
    await Future.delayed(_latency);
    for (final resident in MockData.residents) {
      if (resident.id == id) return resident;
    }
    return null;
  }

  @override
  Future<List<Resident>> getResidentsByIds(List<String> ids) async {
    await Future.delayed(_latency);
    return MockData.residents
        .where((resident) => ids.contains(resident.id))
        .toList();
  }

  @override
  Future<List<Resident>> getResidentsByClinicId(String clinicId) async {
    await Future.delayed(_latency);
    return MockData.residents
        .where((resident) => resident.clinicId == clinicId)
        .toList();
  }

  @override
  Future<Resident> createResident({
    required String name,
    required int age,
    String? clinicId,
    String? roomNumber,
    String? healthNotes,
    String? mood,
    String? peculiarities,
    String? photoPath,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    await Future.delayed(_latency);
    final resident = Resident(
      id: 'resident-${MockData.residents.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      age: age,
      clinicId: clinicId,
      roomNumber: roomNumber,
      healthNotes: healthNotes ?? 'Sem anotações de saúde registradas ainda.',
      mood: mood,
      peculiarities: peculiarities,
      photoPath: photoPath,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
    );
    MockData.residents.add(resident);
    return resident;
  }

  @override
  Future<Resident> updateResident({
    required String id,
    Object? name = Resident.unset,
    Object? age = Resident.unset,
    Object? healthNotes = Resident.unset,
    Object? mood = Resident.unset,
    Object? peculiarities = Resident.unset,
    Object? photoPath = Resident.unset,
    Object? clinicId = Resident.unset,
    Object? roomNumber = Resident.unset,
    Object? emergencyContactName = Resident.unset,
    Object? emergencyContactPhone = Resident.unset,
  }) async {
    await Future.delayed(_latency);
    final index = MockData.residents.indexWhere((r) => r.id == id);
    if (index == -1) {
      throw StateError('Idoso não encontrado: $id');
    }

    final updated = MockData.residents[index].copyWith(
      name: name,
      age: age,
      healthNotes: healthNotes,
      mood: mood,
      peculiarities: peculiarities,
      photoPath: photoPath,
      clinicId: clinicId,
      roomNumber: roomNumber,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
    );
    MockData.residents[index] = updated;
    return updated;
  }

  @override
  Future<Resident> dischargeResident(String id) async {
    await Future.delayed(_latency);
    final index = MockData.residents.indexWhere((r) => r.id == id);
    if (index == -1) {
      throw StateError('Idoso não encontrado: $id');
    }

    final updated = MockData.residents[index].discharge();
    MockData.residents[index] = updated;
    return updated;
  }
}
