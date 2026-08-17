import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/activity_type.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/services/activity_service.dart';
import 'package:care_senior_study/services/resident_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

class ScheduleActivityScreenViewModel extends ChangeNotifier {
  ScheduleActivityScreenViewModel({
    required this.clinicId,
    List<String> preselectedResidentIds = const [],
  }) : selectedResidentIds = {...preselectedResidentIds};

  final String clinicId;

  final _activityService = GetIt.I<ActivityService>();
  final _residentService = GetIt.I<ResidentService>();

  final titleController = TextEditingController();
  final detailController = TextEditingController();

  List<Resident> clinicResidents = [];
  final Set<String> selectedResidentIds;
  String _residentQuery = '';

  String? selectedType;
  TimeOfDay selectedTime = TimeOfDay.now();
  String? photoPath;
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  bool get needsDetail =>
      selectedType == ActivityType.physicalActivity ||
      selectedType == ActivityType.socialGathering ||
      selectedType == ActivityType.other;

  bool get needsPhoto => selectedType == ActivityType.medication;

  List<Resident> get filteredResidents {
    final query = _residentQuery.trim().toLowerCase();
    if (query.isEmpty) return clinicResidents;
    return clinicResidents
        .where((resident) => resident.name.toLowerCase().contains(query))
        .toList();
  }

  bool get allResidentsSelected =>
      clinicResidents.isNotEmpty &&
      selectedResidentIds.length == clinicResidents.length;

  void updateResidentSearch(String value) {
    _residentQuery = value;
    notifyListeners();
  }

  /// Marca/desmarca todos os idosos da clínica de uma vez — ignora o filtro
  /// de busca, já que é um atalho pra atividades pra todo mundo (ex.: "Roda
  /// de música").
  void toggleSelectAllResidents() {
    if (allResidentsSelected) {
      selectedResidentIds.clear();
    } else {
      selectedResidentIds
        ..clear()
        ..addAll(clinicResidents.map((resident) => resident.id));
    }
    notifyListeners();
  }

  String get detailLabel => switch (selectedType) {
    ActivityType.physicalActivity =>
      'Qual atividade (ex.: caminhada, fisioterapia)',
    ActivityType.socialGathering => 'Descrição (ex.: visita da família)',
    _ => 'Descreva o que é',
  };

  Future<void> loadResidents() async {
    isLoading = true;
    notifyListeners();

    clinicResidents = await _residentService.getResidentsForClinic(clinicId);

    isLoading = false;
    notifyListeners();
  }

  void selectType(String type) {
    selectedType = type;
    if (titleController.text.isEmpty) {
      titleController.text = type;
    }
    notifyListeners();
  }

  void selectTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void setPhoto(String path) {
    photoPath = path;
    notifyListeners();
  }

  void toggleResident(String residentId) {
    if (!selectedResidentIds.add(residentId)) {
      selectedResidentIds.remove(residentId);
    }
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    final type = selectedType;
    if (type == null || titleController.text.trim().isEmpty) {
      errorMessage = 'Escolha uma categoria e um título para a atividade.';
      notifyListeners();
      return;
    }

    if (selectedResidentIds.isEmpty) {
      errorMessage = 'Escolha pelo menos um idoso participante.';
      notifyListeners();
      return;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    await _activityService.createActivity(
      clinicId: clinicId,
      residentIds: selectedResidentIds.toList(),
      type: type,
      title: titleController.text.trim(),
      scheduledTime: scheduledTime,
      detail: needsDetail ? detailController.text.trim() : null,
      photoPath: needsPhoto ? photoPath : null,
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  @override
  void dispose() {
    titleController.dispose();
    detailController.dispose();
    super.dispose();
  }
}
