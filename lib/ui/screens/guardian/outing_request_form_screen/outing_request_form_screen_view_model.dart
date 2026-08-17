import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/services/outing_request_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

/// Formulário de nova solicitação de saída: horário de saída/chegada e
/// informações extras (destino, medicação a levar, contato de emergência
/// etc.) — vai pra fila de aprovação da equipe da clínica do idoso.
class OutingRequestFormScreenViewModel extends ChangeNotifier {
  OutingRequestFormScreenViewModel(this.residents)
    : selectedResidentId = residents.length == 1 ? residents.first.id : null;

  final _outingRequestService = GetIt.I<OutingRequestService>();
  final _authStore = GetIt.I<AuthStore>();

  final List<Resident> residents;
  final notesController = TextEditingController();

  String? selectedResidentId;
  DateTime? departureAt;
  DateTime? returnAt;
  bool isSaving = false;
  String? errorMessage;

  void selectResident(String residentId) {
    selectedResidentId = residentId;
    notifyListeners();
  }

  void setDepartureAt(DateTime value) {
    departureAt = value;
    notifyListeners();
  }

  void setReturnAt(DateTime value) {
    returnAt = value;
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    final residentId = selectedResidentId;
    final departureAt = this.departureAt;
    final returnAt = this.returnAt;
    final guardianId = _authStore.guardian?.id;

    if (residentId == null) {
      errorMessage = 'Escolha o idoso que vai sair.';
      notifyListeners();
      return;
    }
    if (departureAt == null || returnAt == null) {
      errorMessage = 'Informe o horário de saída e de chegada.';
      notifyListeners();
      return;
    }
    if (!returnAt.isAfter(departureAt)) {
      errorMessage = 'O horário de chegada deve ser depois da saída.';
      notifyListeners();
      return;
    }
    if (guardianId == null) return;

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    await _outingRequestService.createRequest(
      residentId: residentId,
      guardianId: guardianId,
      departureAt: departureAt,
      returnAt: returnAt,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
