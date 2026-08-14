import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/data/models/resident_mood.dart';
import 'package:care_senior_study/routing/args/medication_register_screen_arguments.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/services/medication_service.dart';
import 'package:care_senior_study/services/resident_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

/// Edição dos dados do idoso pelo próprio responsável — só faz sentido
/// enquanto o idoso ainda não estiver vinculado a uma clínica (depois do
/// vínculo, quem mantém esses dados é a equipe da clínica).
class EditResidentScreenViewModel extends ChangeNotifier {
  EditResidentScreenViewModel({required this.residentId});

  final String residentId;

  final _residentService = GetIt.I<ResidentService>();
  final _medicationService = GetIt.I<MedicationService>();

  static const List<String> moods = ResidentMood.all;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final healthNotesController = TextEditingController();
  final peculiaritiesController = TextEditingController();

  Resident? resident;
  List<Medication> medications = [];
  String? selectedMood;
  String? photoPath;
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    resident = await _residentService.getResidentById(residentId);
    medications = await _medicationService.getMedicationsByResidentId(
      residentId,
    );

    final loadedResident = resident;
    if (loadedResident != null) {
      nameController.text = loadedResident.name;
      ageController.text = loadedResident.age.toString();
      healthNotesController.text = loadedResident.healthNotes;
      peculiaritiesController.text = loadedResident.peculiarities ?? '';
      selectedMood = loadedResident.mood;
      photoPath = loadedResident.photoPath;
    }

    isLoading = false;
    notifyListeners();
  }

  void selectMood(String mood) {
    selectedMood = selectedMood == mood ? null : mood;
    notifyListeners();
  }

  void setPhoto(String path) {
    photoPath = path;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    final age = int.tryParse(ageController.text.trim());
    if (nameController.text.trim().isEmpty || age == null) {
      errorMessage = 'Preencha o nome e a idade corretamente.';
      notifyListeners();
      return;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    await _residentService.updateResident(
      id: residentId,
      name: nameController.text.trim(),
      age: age,
      healthNotes: healthNotesController.text.trim(),
      mood: selectedMood,
      peculiarities: peculiaritiesController.text.trim().isEmpty
          ? null
          : peculiaritiesController.text.trim(),
      photoPath: photoPath,
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  Future<void> navigateToAddMedication(BuildContext context) async {
    final result = await navigator(context).pushNamed(
      Routes.medicationRegisterScreen,
      arguments: MedicationRegisterScreenArguments(residentId: residentId),
    );
    if (result == true) {
      medications = await _medicationService.getMedicationsByResidentId(
        residentId,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    healthNotesController.dispose();
    peculiaritiesController.dispose();
    super.dispose();
  }
}
