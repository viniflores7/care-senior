import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/data/models/activity_status.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/health_record.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/routing/args/activity_detail_screen_arguments.dart';
import 'package:care_senior_study/routing/args/health_record_register_screen_arguments.dart';
import 'package:care_senior_study/routing/args/medication_register_screen_arguments.dart';
import 'package:care_senior_study/routing/args/schedule_activity_screen_arguments.dart';
import 'package:care_senior_study/routing/args/viewer_role.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/services/activity_service.dart';
import 'package:care_senior_study/services/medication_service.dart';
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

  bool get isStaff => viewerRole == ViewerRole.staff;

  Resident? resident;
  Clinic? clinic;
  List<Activity> activities = [];
  List<HealthRecord> healthRecords = [];
  List<Medication> medications = [];
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

    isLoading = false;
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
