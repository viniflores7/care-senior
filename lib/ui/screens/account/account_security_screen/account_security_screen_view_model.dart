import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/services/resident_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

/// Tela de Segurança: dados de conta de quem está logado (colaborador ou
/// responsável) — lida direto do `AuthStore`, sem precisar de argumentos de
/// rota. Instituição só existe (e é fixa) pra colaborador.
class AccountSecurityScreenViewModel extends ChangeNotifier {
  final _authStore = GetIt.I<AuthStore>();
  final _authService = GetIt.I<AuthService>();
  final _residentService = GetIt.I<ResidentService>();

  final nameController = TextEditingController();
  final cpfController = TextEditingController();
  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp('[0-9]')},
  );

  bool isStaff = false;
  String? photoPath;
  String? institutionName;

  /// Idoso ainda não vinculado a uma clínica que este responsável cadastrou
  /// — só ele pode editar os dados enquanto durar essa situação.
  String? unlinkedResidentId;

  bool isLoading = true;
  bool isSaving = false;

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();

    final staff = _authStore.staff;
    final guardian = _authStore.guardian;
    isStaff = staff != null;

    final name = staff?.name ?? guardian?.name ?? '';
    final cpf = staff?.cpf ?? guardian?.cpf ?? '';
    photoPath = staff?.photoPath ?? guardian?.photoPath;

    nameController.text = name;
    cpfMaskFormatter.updateMask(newValue: TextEditingValue(text: cpf));
    cpfController.text = cpfMaskFormatter.getMaskedText();

    if (staff != null) {
      final clinic = await _residentService.getClinicById(staff.clinicId);
      institutionName = clinic?.name;
    } else if (guardian != null) {
      final residents = await _residentService.getResidentsForGuardian(
        guardian.residentIds,
      );
      final unlinkedResidents = residents.where((r) => !r.isLinkedToClinic);
      unlinkedResidentId = unlinkedResidents.isEmpty
          ? null
          : unlinkedResidents.first.id;
    }

    isLoading = false;
    notifyListeners();
  }

  void setPhoto(String path) {
    photoPath = path;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    isSaving = true;
    notifyListeners();

    final cpf = cpfController.text.trim().isEmpty
        ? null
        : cpfController.text.trim();

    final staff = _authStore.staff;
    if (staff != null) {
      await _authService.updateStaffProfile(
        id: staff.id,
        name: name,
        cpf: cpf,
        photoPath: photoPath,
      );
    } else {
      final guardian = _authStore.guardian;
      if (guardian != null) {
        await _authService.updateGuardianProfile(
          id: guardian.id,
          name: name,
          cpf: cpf,
          photoPath: photoPath,
        );
      }
    }

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  @override
  void dispose() {
    nameController.dispose();
    cpfController.dispose();
    super.dispose();
  }
}
