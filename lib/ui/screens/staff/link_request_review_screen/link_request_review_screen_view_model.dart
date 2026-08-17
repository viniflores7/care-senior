import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/pending_link_request.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/services/medication_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

/// Revisão de um vínculo pendente: mostra o perfil de cuidado já preenchido
/// no autocadastro (saúde, humor, peculiaridades, medicamentos) e recebe o
/// quarto de cada idoso antes de aceitar — só preenche `clinicId`/
/// `roomNumber` no registro existente, nenhum dado é redigitado.
class LinkRequestReviewScreenViewModel extends ChangeNotifier {
  LinkRequestReviewScreenViewModel(this.request) {
    for (final resident in request.residents) {
      roomControllers[resident.id] = TextEditingController();
    }
  }

  final _authService = GetIt.I<AuthService>();
  final _authStore = GetIt.I<AuthStore>();
  final _medicationService = GetIt.I<MedicationService>();

  final PendingLinkRequest request;
  final Map<String, TextEditingController> roomControllers = {};
  Map<String, List<Medication>> medicationsByResident = {};

  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    for (final resident in request.residents) {
      medicationsByResident[resident.id] = await _medicationService
          .getMedicationsByResidentId(resident.id);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> accept(BuildContext context) async {
    final clinicId = _authStore.staff?.clinicId;
    if (clinicId == null) return;

    final roomNumberByResidentId = <String, String>{};
    for (final resident in request.residents) {
      final room = roomControllers[resident.id]!.text.trim();
      if (room.isEmpty) {
        errorMessage = 'Informe o quarto de todos os idosos para aceitar.';
        notifyListeners();
        return;
      }
      roomNumberByResidentId[resident.id] = room;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    await _authService.acceptLinkRequest(
      clinicId: clinicId,
      roomNumberByResidentId: roomNumberByResidentId,
    );

    isSaving = false;
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  @override
  void dispose() {
    for (final controller in roomControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
