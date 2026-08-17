import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:care_senior_study/data/models/medication_draft.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/ui/widgets/medication_draft_sheet/medication_draft_sheet.dart';
import 'package:care_senior_study/utils/navigator.dart';

class AddGuardianScreenViewModel extends ChangeNotifier {
  AddGuardianScreenViewModel({this.existingResidentId});

  final _authService = GetIt.I<AuthService>();
  final _authStore = GetIt.I<AuthStore>();

  /// Quando preenchido, a tela só cadastra um responsável a mais pra este
  /// idoso já existente — os campos do idoso ficam escondidos.
  final String? existingResidentId;

  bool get isAddingToExistingResident => existingResidentId != null;

  final guardianNameController = TextEditingController();
  final guardianEmailController = TextEditingController();
  final guardianCpfController = TextEditingController();
  final guardianCpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp('[0-9]')},
  );
  final residentNameController = TextEditingController();
  final residentAgeController = TextEditingController();
  final roomNumberController = TextEditingController();
  final emergencyContactNameController = TextEditingController();
  final emergencyContactPhoneController = TextEditingController();

  String? guardianPhotoPath;
  String? residentPhotoPath;
  List<MedicationDraft> medicationDrafts = [];
  bool isSaving = false;
  String? errorMessage;

  void setGuardianPhoto(String path) {
    guardianPhotoPath = path;
    notifyListeners();
  }

  void setResidentPhoto(String path) {
    residentPhotoPath = path;
    notifyListeners();
  }

  Future<void> addMedicationDraft(BuildContext context) async {
    final draft = await showModalBottomSheet<MedicationDraft>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const MedicationDraftSheet(),
    );
    if (draft == null) return;

    medicationDrafts = [...medicationDrafts, draft];
    notifyListeners();
  }

  void removeMedicationDraft(int index) {
    medicationDrafts = [...medicationDrafts]..removeAt(index);
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    if (guardianNameController.text.trim().isEmpty ||
        guardianEmailController.text.trim().isEmpty ||
        guardianCpfController.text.trim().isEmpty) {
      errorMessage = 'Preencha todos os campos corretamente.';
      notifyListeners();
      return;
    }

    final existingResidentId = this.existingResidentId;
    if (existingResidentId != null) {
      await _saveForExistingResident(context, existingResidentId);
      return;
    }

    final age = int.tryParse(residentAgeController.text.trim());
    if (residentNameController.text.trim().isEmpty ||
        roomNumberController.text.trim().isEmpty ||
        age == null) {
      errorMessage = 'Preencha todos os campos corretamente.';
      notifyListeners();
      return;
    }

    final clinicId = _authStore.staff?.clinicId;
    if (clinicId == null) return;

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    await _authService.createGuardianWithResident(
      guardianName: guardianNameController.text.trim(),
      guardianEmail: guardianEmailController.text.trim(),
      guardianCpf: guardianCpfController.text.trim(),
      guardianPhotoPath: guardianPhotoPath,
      residentName: residentNameController.text.trim(),
      residentAge: age,
      roomNumber: roomNumberController.text.trim(),
      clinicId: clinicId,
      residentPhotoPath: residentPhotoPath,
      emergencyContactName: emergencyContactNameController.text.trim().isEmpty
          ? null
          : emergencyContactNameController.text.trim(),
      emergencyContactPhone:
          emergencyContactPhoneController.text.trim().isEmpty
          ? null
          : emergencyContactPhoneController.text.trim(),
      medicationDrafts: medicationDrafts,
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  Future<void> _saveForExistingResident(
    BuildContext context,
    String residentId,
  ) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    await _authService.addGuardianToResident(
      residentId: residentId,
      guardianName: guardianNameController.text.trim(),
      guardianEmail: guardianEmailController.text.trim(),
      guardianCpf: guardianCpfController.text.trim(),
      guardianPhotoPath: guardianPhotoPath,
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  @override
  void dispose() {
    guardianNameController.dispose();
    guardianEmailController.dispose();
    guardianCpfController.dispose();
    residentNameController.dispose();
    residentAgeController.dispose();
    roomNumberController.dispose();
    emergencyContactNameController.dispose();
    emergencyContactPhoneController.dispose();
    super.dispose();
  }
}
