import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/data/models/activity_status.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/guardian.dart';
import 'package:care_senior_study/data/models/health_record.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/message.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/data/models/staff_role.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/routing/args/activity_detail_screen_arguments.dart';
import 'package:care_senior_study/routing/args/add_guardian_screen_arguments.dart';
import 'package:care_senior_study/routing/args/edit_resident_screen_arguments.dart';
import 'package:care_senior_study/routing/args/health_record_register_screen_arguments.dart';
import 'package:care_senior_study/routing/args/medication_register_screen_arguments.dart';
import 'package:care_senior_study/routing/args/schedule_activity_screen_arguments.dart';
import 'package:care_senior_study/routing/args/viewer_role.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/services/activity_service.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/services/medication_service.dart';
import 'package:care_senior_study/services/message_service.dart';
import 'package:care_senior_study/services/resident_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

class ResidentDetailScreenViewModel extends ChangeNotifier {
  ResidentDetailScreenViewModel({
    required this.residentId,
    required this.viewerRole,
  });

  final String residentId;
  final String viewerRole;

  final _residentService = GetIt.I<ResidentService>();
  final _activityService = GetIt.I<ActivityService>();
  final _medicationService = GetIt.I<MedicationService>();
  final _messageService = GetIt.I<MessageService>();
  final _authService = GetIt.I<AuthService>();
  final _authStore = GetIt.I<AuthStore>();

  bool get isStaff => viewerRole == ViewerRole.staff;

  /// Só coordenadoras/enfermeiras podem adicionar responsável ou desvincular
  /// o idoso da clínica — ações administrativas/sensíveis.
  bool get canManageResidentLink {
    final staff = _authStore.staff;
    return staff != null && StaffRole.canManageRequests(staff.role);
  }

  Resident? resident;
  Clinic? clinic;
  List<Activity> activities = [];
  List<HealthRecord> healthRecords = [];
  List<Medication> medications = [];
  List<Message> messages = [];
  List<Guardian> guardians = [];
  bool isLoading = true;

  List<Activity> get _todayActivities {
    final now = DateTime.now();
    return activities.where((activity) {
      final scheduled = activity.scheduledTime;
      return scheduled.year == now.year &&
          scheduled.month == now.month &&
          scheduled.day == now.day;
    }).toList();
  }

  int get completedCount => _todayActivities
      .where(
        (activity) =>
            activity.participantFor(residentId)?.status ==
            ActivityStatus.completed,
      )
      .length;

  int get totalCount => _todayActivities.length;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    resident = await _residentService.getResidentById(residentId);
    final clinicId = resident?.clinicId;
    if (clinicId != null) {
      clinic = await _residentService.getClinicById(clinicId);
    }
    activities = await _activityService.getActivitiesByResidentId(residentId);
    healthRecords = await _activityService.getHealthRecordsByResidentId(
      residentId,
    );
    medications = await _medicationService.getMedicationsByResidentId(
      residentId,
    );
    messages = await _messageService.getMessagesByResidentId(residentId);
    guardians = await _authService.getGuardiansByResidentId(residentId);

    isLoading = false;
    notifyListeners();
  }

  /// Só a equipe chega aqui (o responsável edita pela Segurança, enquanto o
  /// idoso não estiver vinculado) — usa a mesma tela de edição de perfil.
  Future<void> navigateToEditProfile(BuildContext context) async {
    final result = await navigator(context).pushNamed(
      Routes.editResidentScreen,
      arguments: EditResidentScreenArguments(residentId: residentId),
    );
    if (result == true) {
      await loadData();
    }
  }

  Future<void> navigateToAddGuardian(BuildContext context) async {
    final result = await navigator(context).pushNamed(
      Routes.staffAddGuardianScreen,
      arguments: AddGuardianScreenArguments(residentId: residentId),
    );
    if (result == true) {
      await loadData();
    }
  }

  /// Desvincula o idoso da clínica atual (alta, transferência ou correção
  /// de cadastro) — some da lista de idosos da clínica, então fecha a tela.
  Future<void> unlinkFromClinic(BuildContext context) async {
    await _residentService.dischargeResident(residentId);
    if (!context.mounted) return;

    navigator(context).pop(true);
  }

  Future<void> sendMessage(String text) async {
    final senderName = isStaff
        ? _authStore.staff?.name
        : _authStore.guardian?.name;
    if (senderName == null) return;

    final message = await _messageService.sendMessage(
      residentId: residentId,
      senderRole: viewerRole,
      senderName: senderName,
      text: text,
    );
    messages = [...messages, message];
    notifyListeners();
  }

  Future<void> viewActivityDetail(
    BuildContext context,
    Activity activity,
  ) async {
    // A tela de detalhe não fecha mais sozinha a cada ação (permite tratar
    // vários idosos numa mesma sessão), então recarregamos sempre ao voltar.
    await navigator(context).pushNamed(
      Routes.activityDetailScreen,
      arguments: ActivityDetailScreenArguments(
        activity: activity,
        viewerRole: viewerRole,
        focusResidentId: residentId,
      ),
    );
    await loadData();
  }

  Future<void> scheduleActivity(BuildContext context) async {
    final resident = this.resident;
    // Só a equipe (já vinculada à clínica do idoso) chega a essa ação.
    if (resident == null || resident.clinicId == null) return;

    final created = await navigator(context).pushNamed(
      Routes.staffScheduleActivityScreen,
      arguments: ScheduleActivityScreenArguments(
        clinicId: resident.clinicId!,
        preselectedResidentIds: [residentId],
      ),
    );
    if (created == true) {
      await loadData();
    }
  }

  Future<void> navigateToAddHealthRecord(BuildContext context) async {
    final result = await navigator(context).pushNamed(
      Routes.healthRecordRegisterScreen,
      arguments: HealthRecordRegisterScreenArguments(residentId: residentId),
    );
    if (result == true) {
      await loadData();
    }
  }

  Future<void> navigateToAddMedication(BuildContext context) async {
    final result = await navigator(context).pushNamed(
      Routes.medicationRegisterScreen,
      arguments: MedicationRegisterScreenArguments(residentId: residentId),
    );
    if (result == true) {
      await loadData();
    }
  }
}
