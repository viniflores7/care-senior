import 'package:care_senior_study/data/mock/mock_data.dart';
import 'package:care_senior_study/data/models/guardian.dart';
import 'package:care_senior_study/data/models/staff_member.dart';

/// Senha única mockada para todos os usuários de teste, já que não existe
/// backend real de autenticação neste projeto de estudo.
const String mockPassword = '123456';

abstract class AuthRepository {
  Future<Guardian?> loginGuardian({
    required String email,
    required String password,
  });

  Future<StaffMember?> loginStaff({
    required String email,
    required String password,
  });

  Future<Guardian> createGuardian({
    required String name,
    required String email,
    required String cpf,
    required String residentId,
    String? photoPath,
  });

  Future<Guardian> markClinicContacted({
    required String guardianId,
    required String clinicId,
  });

  Future<StaffMember> updateStaffProfile({
    required String id,
    required String name,
    String? cpf,
    String? photoPath,
  });

  Future<Guardian> updateGuardianProfile({
    required String id,
    required String name,
    String? cpf,
    String? photoPath,
  });
}

class MockAuthRepository implements AuthRepository {
  static const _latency = Duration(milliseconds: 300);

  final List<Guardian> _guardians = List.of(MockData.guardians);

  @override
  Future<Guardian?> loginGuardian({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_latency);
    if (password != mockPassword) return null;

    for (final guardian in _guardians) {
      if (guardian.email == email) return guardian;
    }
    return null;
  }

  @override
  Future<StaffMember?> loginStaff({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_latency);
    if (password != mockPassword) return null;

    for (final staff in MockData.staffMembers) {
      if (staff.email == email) return staff;
    }
    return null;
  }

  @override
  Future<Guardian> createGuardian({
    required String name,
    required String email,
    required String cpf,
    required String residentId,
    String? photoPath,
  }) async {
    await Future.delayed(_latency);
    final guardian = Guardian(
      id: 'guardian-${_guardians.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      email: email,
      cpf: cpf,
      photoPath: photoPath,
      residentIds: [residentId],
    );
    _guardians.add(guardian);
    return guardian;
  }

  @override
  Future<Guardian> markClinicContacted({
    required String guardianId,
    required String clinicId,
  }) async {
    await Future.delayed(_latency);
    final index = _guardians.indexWhere((g) => g.id == guardianId);
    if (index == -1) {
      throw StateError('Responsável não encontrado: $guardianId');
    }

    final guardian = _guardians[index];
    if (guardian.contactedClinicIds.contains(clinicId)) return guardian;

    final updated = guardian.copyWith(
      contactedClinicIds: [...guardian.contactedClinicIds, clinicId],
    );
    _guardians[index] = updated;
    return updated;
  }

  @override
  Future<StaffMember> updateStaffProfile({
    required String id,
    required String name,
    String? cpf,
    String? photoPath,
  }) async {
    await Future.delayed(_latency);
    final index = MockData.staffMembers.indexWhere((staff) => staff.id == id);
    if (index == -1) {
      throw StateError('Colaborador não encontrado: $id');
    }

    final updated = MockData.staffMembers[index].copyWith(
      name: name,
      cpf: cpf,
      photoPath: photoPath,
    );
    MockData.staffMembers[index] = updated;
    return updated;
  }

  @override
  Future<Guardian> updateGuardianProfile({
    required String id,
    required String name,
    String? cpf,
    String? photoPath,
  }) async {
    await Future.delayed(_latency);
    final index = _guardians.indexWhere((guardian) => guardian.id == id);
    if (index == -1) {
      throw StateError('Responsável não encontrado: $id');
    }

    final updated = _guardians[index].copyWith(
      name: name,
      cpf: cpf,
      photoPath: photoPath,
    );
    _guardians[index] = updated;
    return updated;
  }
}
