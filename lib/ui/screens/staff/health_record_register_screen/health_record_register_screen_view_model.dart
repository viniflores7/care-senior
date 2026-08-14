import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/services/activity_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

class HealthRecordRegisterScreenViewModel extends ChangeNotifier {
  HealthRecordRegisterScreenViewModel({required this.residentId});

  final String residentId;

  final _activityService = GetIt.I<ActivityService>();
  final _authStore = GetIt.I<AuthStore>();

  static const List<String> types = [
    'Pressão arterial',
    'Glicose',
    'Peso',
    'Temperatura',
    'Frequência cardíaca',
  ];

  String selectedType = types.first;
  final valueController = TextEditingController();
  bool isSaving = false;

  void selectType(String type) {
    selectedType = type;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    if (valueController.text.trim().isEmpty) return;

    isSaving = true;
    notifyListeners();

    await _activityService.addHealthRecord(
      residentId: residentId,
      type: selectedType,
      value: valueController.text.trim(),
      recordedBy: _authStore.staff?.name ?? 'Equipe da clínica',
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }
}
