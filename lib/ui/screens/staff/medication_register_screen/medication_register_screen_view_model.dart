import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/medication_form.dart';
import 'package:care_senior_study/services/medication_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

class MedicationRegisterScreenViewModel extends ChangeNotifier {
  MedicationRegisterScreenViewModel({required this.residentId});

  final String residentId;

  final _medicationService = GetIt.I<MedicationService>();

  static const List<String> forms = MedicationForm.all;

  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final frequencyController = TextEditingController();
  final instructionsController = TextEditingController();
  final prescribedByController = TextEditingController();

  String selectedForm = forms.first;
  bool isSaving = false;
  String? errorMessage;

  void selectForm(String form) {
    selectedForm = form;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        dosageController.text.trim().isEmpty ||
        frequencyController.text.trim().isEmpty) {
      errorMessage = 'Preencha nome, dosagem e frequência.';
      notifyListeners();
      return;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    await _medicationService.addMedication(
      residentId: residentId,
      name: nameController.text.trim(),
      dosage: dosageController.text.trim(),
      form: selectedForm,
      frequency: frequencyController.text.trim(),
      startDate: DateTime.now(),
      instructions: instructionsController.text.trim().isEmpty
          ? null
          : instructionsController.text.trim(),
      prescribedBy: prescribedByController.text.trim().isEmpty
          ? null
          : prescribedByController.text.trim(),
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    instructionsController.dispose();
    prescribedByController.dispose();
    super.dispose();
  }
}
