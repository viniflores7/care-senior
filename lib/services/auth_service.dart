import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/guardian.dart';
import 'package:care_senior_study/data/models/medication_draft.dart';
import 'package:care_senior_study/data/models/pending_link_request.dart';
import 'package:care_senior_study/data/models/staff_member.dart';
import 'package:care_senior_study/data/repositories/auth_repository.dart';
import 'package:care_senior_study/data/repositories/medication_repository.dart';
import 'package:care_senior_study/data/repositories/resident_repository.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/routing/routes.dart';

class AuthService {
  final _authRepository = GetIt.I<AuthRepository>();
  final _residentRepository = GetIt.I<ResidentRepository>();
  final _medicationRepository = GetIt.I<MedicationRepository>();
  final _authStore = GetIt.I<AuthStore>();

  Future<void> _saveMedicationDrafts(
    String residentId,
    List<MedicationDraft> drafts,
  ) async {
    for (final draft in drafts) {
      await _medicationRepository.addMedication(
        residentId: residentId,
        name: draft.name,
        dosage: draft.dosage,
        form: draft.form,
        frequency: draft.frequency,
        startDate: DateTime.now(),
        instructions: draft.instructions,
        prescribedBy: draft.prescribedBy,
      );
    }
  }

  Future<bool> loginGuardian({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final guardian = await _authRepository.loginGuardian(
      email: email,
      password: password,
    );
    if (guardian == null) return false;

    _authStore.setGuardian(guardian);
    if (!context.mounted) return true;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.guardianHomeScreen, (route) => false);
    return true;
  }

  Future<bool> loginStaff({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final staff = await _authRepository.loginStaff(
      email: email,
      password: password,
    );
    if (staff == null) return false;

    _authStore.setStaff(staff);
    if (!context.mounted) return true;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.staffHomeScreen, (route) => false);
    return true;
  }

  Future<Guardian> createGuardianWithResident({
    required String guardianName,
    required String guardianEmail,
    required String guardianCpf,
    required String residentName,
    required int residentAge,
    required String roomNumber,
    required String clinicId,
    String? guardianPhotoPath,
    String? residentPhotoPath,
    String? emergencyContactName,
    String? emergencyContactPhone,
    List<MedicationDraft> medicationDrafts = const [],
  }) async {
    final resident = await _residentRepository.createResident(
      name: residentName,
      age: residentAge,
      clinicId: clinicId,
      roomNumber: roomNumber,
      photoPath: residentPhotoPath,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
    );

    await _saveMedicationDrafts(resident.id, medicationDrafts);

    return _authRepository.createGuardian(
      name: guardianName,
      email: guardianEmail,
      cpf: guardianCpf,
      photoPath: guardianPhotoPath,
      residentId: resident.id,
    );
  }

  /// Cadastro feito pelo próprio responsável, antes de qualquer vínculo com
  /// uma clínica — o idoso já entra com todos os dados de cuidado (saúde,
  /// humor, peculiaridades), só falta a clínica linkar quando o contato der
  /// certo (ver [markClinicContacted]).
  Future<bool> registerGuardian({
    required BuildContext context,
    required String guardianName,
    required String guardianEmail,
    required String guardianCpf,
    required String residentName,
    required int residentAge,
    String? guardianPhotoPath,
    String? residentHealthNotes,
    String? residentMood,
    String? residentPeculiarities,
    String? residentPhotoPath,
    String? emergencyContactName,
    String? emergencyContactPhone,
    List<MedicationDraft> medicationDrafts = const [],
  }) async {
    final resident = await _residentRepository.createResident(
      name: residentName,
      age: residentAge,
      healthNotes: residentHealthNotes,
      mood: residentMood,
      peculiarities: residentPeculiarities,
      photoPath: residentPhotoPath,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
    );

    await _saveMedicationDrafts(resident.id, medicationDrafts);

    final guardian = await _authRepository.createGuardian(
      name: guardianName,
      email: guardianEmail,
      cpf: guardianCpf,
      photoPath: guardianPhotoPath,
      residentId: resident.id,
    );

    _authStore.setGuardian(guardian);
    if (!context.mounted) return true;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.guardianHomeScreen, (route) => false);
    return true;
  }

  Future<void> markClinicContacted({
    required String guardianId,
    required String clinicId,
  }) async {
    final updated = await _authRepository.markClinicContacted(
      guardianId: guardianId,
      clinicId: clinicId,
    );
    _authStore.updateGuardian(updated);
  }

  /// Responsáveis que contataram [clinicId] e ainda têm idoso(s) sem
  /// vínculo — fila da tela de solicitações de vínculo da equipe.
  Future<List<PendingLinkRequest>> getPendingLinkRequests(
    String clinicId,
  ) async {
    final guardians = await _authRepository.getGuardiansByContactedClinic(
      clinicId,
    );

    final requests = <PendingLinkRequest>[];
    for (final guardian in guardians) {
      final residents = await _residentRepository.getResidentsByIds(
        guardian.residentIds,
      );
      final pendingResidents = residents
          .where((resident) => !resident.isLinkedToClinic)
          .toList();
      if (pendingResidents.isNotEmpty) {
        requests.add(
          PendingLinkRequest(guardian: guardian, residents: pendingResidents),
        );
      }
    }
    return requests;
  }

  /// Aceita o vínculo preenchendo `clinicId`/`roomNumber` de cada idoso já
  /// cadastrado — nenhum dado do responsável ou do idoso é redigitado.
  Future<void> acceptLinkRequest({
    required String clinicId,
    required Map<String, String> roomNumberByResidentId,
  }) async {
    for (final entry in roomNumberByResidentId.entries) {
      await _residentRepository.updateResident(
        id: entry.key,
        clinicId: clinicId,
        roomNumber: entry.value,
      );
    }
  }

  Future<Guardian?> getGuardianById(String id) {
    return _authRepository.getGuardianById(id);
  }

  /// Responsáveis já cadastrados que acompanham este idoso — um idoso pode
  /// ter mais de um (ex.: cônjuge + filho), cada um com seu próprio login.
  Future<List<Guardian>> getGuardiansByResidentId(String residentId) {
    return _authRepository.getGuardiansByResidentId(residentId);
  }

  /// Cadastra um responsável novo e o vincula a um idoso **já existente**
  /// (e já vinculado a uma clínica) — usado quando mais de uma pessoa
  /// acompanha o mesmo idoso. Diferente de [createGuardianWithResident], não
  /// cria um `Resident` novo.
  Future<Guardian> addGuardianToResident({
    required String residentId,
    required String guardianName,
    required String guardianEmail,
    required String guardianCpf,
    String? guardianPhotoPath,
  }) {
    return _authRepository.createGuardian(
      name: guardianName,
      email: guardianEmail,
      cpf: guardianCpf,
      photoPath: guardianPhotoPath,
      residentId: residentId,
    );
  }

  void logout(BuildContext context) {
    _authStore.logout();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.roleSelectionScreen, (route) => false);
  }

  Future<StaffMember> updateStaffProfile({
    required String id,
    required String name,
    String? cpf,
    String? photoPath,
  }) async {
    final updated = await _authRepository.updateStaffProfile(
      id: id,
      name: name,
      cpf: cpf,
      photoPath: photoPath,
    );
    _authStore.updateStaff(updated);
    return updated;
  }

  Future<Guardian> updateGuardianProfile({
    required String id,
    required String name,
    String? cpf,
    String? photoPath,
  }) async {
    final updated = await _authRepository.updateGuardianProfile(
      id: id,
      name: name,
      cpf: cpf,
      photoPath: photoPath,
    );
    _authStore.updateGuardian(updated);
    return updated;
  }
}
