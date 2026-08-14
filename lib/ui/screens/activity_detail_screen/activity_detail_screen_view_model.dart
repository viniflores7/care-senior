import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/data/models/activity_participant.dart';
import 'package:care_senior_study/data/models/activity_status.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/routing/args/viewer_role.dart';
import 'package:care_senior_study/services/activity_service.dart';
import 'package:care_senior_study/services/resident_service.dart';
import 'package:care_senior_study/ui/screens/activity_detail_screen/widgets/activity_outcome_sheet.dart';
import 'package:care_senior_study/ui/screens/activity_detail_screen/widgets/skip_reason_sheet.dart';

/// Regras de quando mostrar as ações de iniciar/pular/concluir no detalhe da
/// atividade — só a equipe da clínica, só enquanto o participante ainda
/// estiver em aberto e, se a tela foi aberta a partir da agenda de um idoso
/// específico ([focusResidentId]), só para aquele idoso.
///
/// Ao contrário da versão anterior, as ações não fecham mais a tela a cada
/// participante — [activity] é atualizada localmente e a tela permanece
/// aberta, para dar conta de vários idosos numa mesma sessão de trabalho.
class ActivityDetailScreenViewModel extends ChangeNotifier {
  ActivityDetailScreenViewModel({
    required this.activity,
    required this.viewerRole,
    this.focusResidentId,
  });

  Activity activity;
  final String viewerRole;
  final String? focusResidentId;

  final _activityService = GetIt.I<ActivityService>();
  final _residentService = GetIt.I<ResidentService>();
  final _authStore = GetIt.I<AuthStore>();

  bool isLoading = true;
  Map<String, Resident> _residentsById = {};

  bool isSelecting = false;
  final Set<String> _selectedResidentIds = {};

  bool get isStaff => viewerRole == ViewerRole.staff;

  List<ActivityParticipant> get participants => activity.participants;

  int get completedCount => activity.completedCount;

  int get totalCount => activity.totalCount;

  Resident? residentFor(String residentId) => _residentsById[residentId];

  bool _isFocused(ActivityParticipant participant) {
    return focusResidentId == null || focusResidentId == participant.residentId;
  }

  /// Se existe pelo menos um participante ainda não iniciado, mostra a ação
  /// "Iniciar atividade" (que inicia todos de uma vez).
  bool get canStartAny {
    if (!isStaff) return false;
    return participants.any(
      (p) => ActivityStatus.startable.contains(p.status) && _isFocused(p),
    );
  }

  /// Concluir/pular vale para qualquer status ainda em aberto, incluindo
  /// "em andamento".
  bool canRegisterOutcomeFor(ActivityParticipant participant) {
    if (!isStaff || !ActivityStatus.open.contains(participant.status)) {
      return false;
    }
    return _isFocused(participant);
  }

  bool isSelected(String residentId) =>
      _selectedResidentIds.contains(residentId);

  int get selectedCount => _selectedResidentIds.length;

  void toggleSelectionMode() {
    isSelecting = !isSelecting;
    _selectedResidentIds.clear();
    notifyListeners();
  }

  void toggleSelected(String residentId) {
    if (!_selectedResidentIds.remove(residentId)) {
      _selectedResidentIds.add(residentId);
    }
    notifyListeners();
  }

  Future<void> loadResidents() async {
    isLoading = true;
    notifyListeners();

    final residents = await _residentService.getResidentsForClinic(
      activity.clinicId,
    );
    _residentsById = {for (final resident in residents) resident.id: resident};

    isLoading = false;
    notifyListeners();
  }

  Future<void> startAll() async {
    activity = await _activityService.startAllParticipants(
      activityId: activity.id,
      registeredBy: _authStore.staff?.name ?? 'Equipe da clínica',
    );
    notifyListeners();
  }

  Future<void> completeActivity(BuildContext context, String residentId) async {
    final outcome = await _showOutcomeSheet(context);
    if (outcome == null) return;

    activity = await _activityService.completeActivity(
      activityId: activity.id,
      residentId: residentId,
      registeredBy: _authStore.staff?.name ?? 'Equipe da clínica',
      rating: outcome.$1,
      comment: outcome.$2,
    );
    notifyListeners();
  }

  Future<void> skipActivity(BuildContext context, String residentId) async {
    final reason = await _showSkipSheet(context);
    if (reason == null) return;

    activity = await _activityService.skipActivity(
      activityId: activity.id,
      residentId: residentId,
      registeredBy: _authStore.staff?.name ?? 'Equipe da clínica',
      reason: reason,
    );
    notifyListeners();
  }

  /// Aplica a mesma nota/comentário a todos os idosos selecionados de uma
  /// vez — a "ferramenta de organização" que evita repetir a ação idoso a
  /// idoso quando o resultado foi o mesmo para o grupo.
  Future<void> completeSelected(BuildContext context) async {
    final outcome = await _showOutcomeSheet(
      context,
      title: 'Como foi para os $selectedCount idosos selecionados?',
    );
    if (outcome == null) return;

    final registeredBy = _authStore.staff?.name ?? 'Equipe da clínica';
    for (final residentId in List.of(_selectedResidentIds)) {
      activity = await _activityService.completeActivity(
        activityId: activity.id,
        residentId: residentId,
        registeredBy: registeredBy,
        rating: outcome.$1,
        comment: outcome.$2,
      );
    }
    isSelecting = false;
    _selectedResidentIds.clear();
    notifyListeners();
  }

  Future<void> skipSelected(BuildContext context) async {
    final reason = await _showSkipSheet(context);
    if (reason == null) return;

    final registeredBy = _authStore.staff?.name ?? 'Equipe da clínica';
    for (final residentId in List.of(_selectedResidentIds)) {
      activity = await _activityService.skipActivity(
        activityId: activity.id,
        residentId: residentId,
        registeredBy: registeredBy,
        reason: reason,
      );
    }
    isSelecting = false;
    _selectedResidentIds.clear();
    notifyListeners();
  }

  Future<(int, String?)?> _showOutcomeSheet(
    BuildContext context, {
    String title = 'Como foi para o idoso?',
  }) {
    return showModalBottomSheet<(int, String?)>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ActivityOutcomeSheet(title: title),
    );
  }

  Future<String?> _showSkipSheet(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const SkipReasonSheet(),
    );
  }
}
