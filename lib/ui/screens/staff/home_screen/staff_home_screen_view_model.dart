import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/health_record.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/outing_request_status.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/data/models/staff_role.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/routing/args/activity_detail_screen_arguments.dart';
import 'package:care_senior_study/routing/args/health_record_register_screen_arguments.dart';
import 'package:care_senior_study/routing/args/medication_register_screen_arguments.dart';
import 'package:care_senior_study/routing/args/resident_detail_screen_arguments.dart';
import 'package:care_senior_study/routing/args/schedule_activity_screen_arguments.dart';
import 'package:care_senior_study/routing/args/viewer_role.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/services/activity_service.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/services/medication_service.dart';
import 'package:care_senior_study/services/notification_service.dart';
import 'package:care_senior_study/services/outing_request_service.dart';
import 'package:care_senior_study/services/resident_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

class StaffHomeScreenViewModel extends ChangeNotifier {
  final _residentService = GetIt.I<ResidentService>();
  final _activityService = GetIt.I<ActivityService>();
  final _authService = GetIt.I<AuthService>();
  final _authStore = GetIt.I<AuthStore>();
  final _notificationService = GetIt.I<NotificationService>();
  final _medicationService = GetIt.I<MedicationService>();
  final _outingRequestService = GetIt.I<OutingRequestService>();

  Clinic? clinic;
  List<Resident> residents = [];
  List<Activity> todayActivities = [];
  List<Activity> tomorrowActivities = [];
  List<HealthRecord> healthRecords = [];
  List<Medication> medications = [];
  int pendingLinkRequestsCount = 0;
  int pendingOutingRequestsCount = 0;
  bool isLoading = true;
  bool hasUnreadNotifications = false;

  String get staffName => _authStore.staff?.name ?? '';
  String? get staffPhotoPath => _authStore.staff?.photoPath;
  String get staffEmail => _authStore.staff?.email ?? '';

  /// Só coordenadoras/enfermeiras veem as filas de solicitações — ver
  /// `StaffRole.canManageRequests`.
  bool get canManageRequests {
    final staff = _authStore.staff;
    return staff != null && StaffRole.canManageRequests(staff.role);
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    final staff = _authStore.staff;
    if (staff == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    clinic = await _residentService.getClinicById(staff.clinicId);
    residents = await _residentService.getResidentsForClinic(staff.clinicId);

    final activities = await _activityService.getActivitiesByClinicId(
      staff.clinicId,
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    todayActivities =
        activities
            .where((activity) => _isSameDay(activity.scheduledTime, today))
            .toList()
          ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    tomorrowActivities =
        activities
            .where((activity) => _isSameDay(activity.scheduledTime, tomorrow))
            .toList()
          ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

    final residentIds = residents.map((resident) => resident.id).toList();
    healthRecords = await _activityService.getHealthRecordsByClinicId(
      residentIds,
    );
    medications = await _medicationService.getMedicationsByClinic(residentIds);
    pendingLinkRequestsCount = (await _authService.getPendingLinkRequests(
      staff.clinicId,
    )).length;
    final outingRequests = await _outingRequestService
        .getRequestsByResidentIds(residentIds);
    pendingOutingRequestsCount = outingRequests
        .where((request) => request.status == OutingRequestStatus.pending)
        .length;

    final notifications = await _notificationService.getNotifications(
      viewerRole: ViewerRole.staff,
    );
    hasUnreadNotifications = notifications.any((n) => !n.read);

    isLoading = false;
    notifyListeners();
  }

  bool _isSameDay(DateTime date, DateTime day) {
    return date.year == day.year &&
        date.month == day.month &&
        date.day == day.day;
  }

  Future<void> navigateToScheduleActivity(BuildContext context) async {
    final clinic = this.clinic;
    if (clinic == null) return;

    final created = await navigator(context).pushNamed(
      Routes.staffScheduleActivityScreen,
      arguments: ScheduleActivityScreenArguments(clinicId: clinic.id),
    );
    if (created == true) {
      await loadData();
    }
  }

  Future<void> navigateToActivityDetail(
    BuildContext context,
    Activity activity,
  ) async {
    // A tela de detalhe não fecha mais sozinha a cada ação (permite tratar
    // vários idosos numa mesma sessão), então recarregamos sempre ao voltar.
    await navigator(context).pushNamed(
      Routes.activityDetailScreen,
      arguments: ActivityDetailScreenArguments(
        activity: activity,
        viewerRole: ViewerRole.staff,
      ),
    );
    await loadData();
  }

  Future<void> navigateToAddHealthRecord(
    BuildContext context,
    String residentId,
  ) async {
    final result = await navigator(context).pushNamed(
      Routes.healthRecordRegisterScreen,
      arguments: HealthRecordRegisterScreenArguments(residentId: residentId),
    );
    if (result == true) {
      await loadData();
    }
  }

  Future<void> navigateToAddMedication(
    BuildContext context,
    String residentId,
  ) async {
    final result = await navigator(context).pushNamed(
      Routes.medicationRegisterScreen,
      arguments: MedicationRegisterScreenArguments(residentId: residentId),
    );
    if (result == true) {
      await loadData();
    }
  }

  Future<void> navigateToResidentDetail(
    BuildContext context,
    String residentId,
  ) async {
    // Desvincular o idoso muda o roster da clínica, então recarregamos
    // sempre ao voltar.
    await navigator(context).pushNamed(
      Routes.residentDetailScreen,
      arguments: ResidentDetailScreenArguments(
        residentId: residentId,
        viewerRole: ViewerRole.staff,
      ),
    );
    await loadData();
  }

  Future<void> navigateToAddGuardian(BuildContext context) async {
    final result = await navigator(
      context,
    ).pushNamed(Routes.staffAddGuardianScreen);
    if (result == true) {
      await loadData();
    }
  }

  Future<void> navigateToLinkRequests(BuildContext context) async {
    await navigator(context).pushNamed(Routes.staffLinkRequestsScreen);
    await loadData();
  }

  Future<void> navigateToOutingRequests(BuildContext context) async {
    await navigator(context).pushNamed(Routes.staffOutingRequestsScreen);
    await loadData();
  }

  Future<void> navigateToNotifications(BuildContext context) async {
    await navigator(context).pushNamed(Routes.notificationsScreen);
    hasUnreadNotifications = false;
    notifyListeners();
  }

  Future<void> navigateToAccountSecurity(BuildContext context) async {
    final result = await navigator(
      context,
    ).pushNamed(Routes.accountSecurityScreen);
    if (result == true) {
      notifyListeners();
    }
  }

  void logout(BuildContext context) {
    _authService.logout(context);
  }
}
