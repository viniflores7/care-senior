import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:care_senior_study/data/models/medication_draft.dart';
import 'package:care_senior_study/data/models/resident_mood.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/ui/widgets/medication_draft_sheet/medication_draft_sheet.dart';

/// Cadastro do responsável em duas etapas: (1) quem ele é, (2) o idoso que
/// ele cuida — já com saúde/humor/peculiaridades/medicamentos, mesmo sem
/// clínica vinculada ainda. Ver `AuthService.registerGuardian`.
class GuardianRegisterScreenViewModel extends ChangeNotifier {
  final _authService = GetIt.I<AuthService>();

  static const List<String> moods = ResidentMood.all;

  int step = 0;

  final guardianNameController = TextEditingController();
  final guardianEmailController = TextEditingController();
  final guardianCpfController = TextEditingController();
  final guardianCpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp('[0-9]')},
  );

  final residentNameController = TextEditingController();
  final residentAgeController = TextEditingController();
  final healthNotesController = TextEditingController();
  final peculiaritiesController = TextEditingController();

  String? selectedMood;
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

  void selectMood(String mood) {
    selectedMood = selectedMood == mood ? null : mood;
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

  void goToResidentStep() {
    if (guardianNameController.text.trim().isEmpty ||
        guardianEmailController.text.trim().isEmpty ||
        guardianCpfController.text.trim().isEmpty) {
      errorMessage = 'Preencha seu nome, e-mail e CPF para continuar.';
      notifyListeners();
      return;
    }

    errorMessage = null;
    step = 1;
    notifyListeners();
  }

  void goBackToGuardianStep() {
    errorMessage = null;
    step = 0;
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    final age = int.tryParse(residentAgeController.text.trim());
    if (residentNameController.text.trim().isEmpty || age == null) {
      errorMessage = 'Preencha o nome e a idade do idoso corretamente.';
      notifyListeners();
      return;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    await _authService.registerGuardian(
      context: context,
      guardianName: guardianNameController.text.trim(),
      guardianEmail: guardianEmailController.text.trim(),
      guardianCpf: guardianCpfController.text.trim(),
      guardianPhotoPath: guardianPhotoPath,
      residentName: residentNameController.text.trim(),
      residentAge: age,
      residentHealthNotes: healthNotesController.text.trim().isEmpty
          ? null
          : healthNotesController.text.trim(),
      residentMood: selectedMood,
      residentPeculiarities: peculiaritiesController.text.trim().isEmpty
          ? null
          : peculiaritiesController.text.trim(),
      residentPhotoPath: residentPhotoPath,
      medicationDrafts: medicationDrafts,
    );

    isSaving = false;
    notifyListeners();
  }

  @override
  void dispose() {
    guardianNameController.dispose();
    guardianEmailController.dispose();
    guardianCpfController.dispose();
    residentNameController.dispose();
    residentAgeController.dispose();
    healthNotesController.dispose();
    peculiaritiesController.dispose();
    super.dispose();
  }
}
