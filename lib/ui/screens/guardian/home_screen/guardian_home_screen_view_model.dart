import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/routing/args/resident_detail_screen_arguments.dart';
import 'package:care_senior_study/routing/args/viewer_role.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/services/notification_service.dart';
import 'package:care_senior_study/services/resident_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

class GuardianHomeScreenViewModel extends ChangeNotifier {
  final _residentService = GetIt.I<ResidentService>();
  final _authService = GetIt.I<AuthService>();
  final _authStore = GetIt.I<AuthStore>();
  final _notificationService = GetIt.I<NotificationService>();

  List<Resident> residents = [];
  List<Clinic> _allClinics = [];
  bool isLoading = true;
  bool hasUnreadNotifications = false;

  String get guardianName => _authStore.guardian?.name ?? '';
  String? get guardianPhotoPath => _authStore.guardian?.photoPath;
  String get guardianEmail => _authStore.guardian?.email ?? '';

  /// Vira `true` assim que algum idoso do responsável estiver vinculado a
  /// uma clínica — antes disso, o menu é reduzido (só Clínicas e Perfil) e
  /// a aba "Clínicas" mostra busca em vez das informações de uma clínica.
  bool get isLinked => residents.any((r) => r.isLinkedToClinic);

  Set<String> get _linkedClinicIds => residents
      .where((r) => r.clinicId != null)
      .map((r) => r.clinicId!)
      .toSet();

  /// Só as clínicas do(s) idoso(s) já vinculado(s) — usada na aba "Clínica"
  /// quando [isLinked].
  List<Clinic> get linkedClinics =>
      _allClinics.where((c) => _linkedClinicIds.contains(c.id)).toList();

  /// Clínicas ainda não contatadas e não vinculadas — a lista de "buscar
  /// clínicas" propriamente dita.
  List<Clinic> get clinicsToContact {
    final contacted = _authStore.guardian?.contactedClinicIds ?? [];
    final linked = _linkedClinicIds;
    return _allClinics
        .where((c) => !contacted.contains(c.id) && !linked.contains(c.id))
        .toList();
  }

  /// Clínicas já contatadas, aguardando a equipe confirmar o vínculo.
  List<Clinic> get contactedClinics {
    final contacted = _authStore.guardian?.contactedClinicIds ?? [];
    return _allClinics.where((c) => contacted.contains(c.id)).toList();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    final guardian = _authStore.guardian;
    residents = guardian == null
        ? []
        : await _residentService.getResidentsForGuardian(guardian.residentIds);
    _allClinics = await _residentService.getAllClinics();

    final notifications = await _notificationService.getNotifications(
      viewerRole: ViewerRole.guardian,
    );
    hasUnreadNotifications = notifications.any((n) => !n.read);

    isLoading = false;
    notifyListeners();
  }

  void navigateToResidentDetail(BuildContext context, String residentId) {
    navigator(context).pushNamed(
      Routes.residentDetailScreen,
      arguments: ResidentDetailScreenArguments(
        residentId: residentId,
        viewerRole: ViewerRole.guardian,
      ),
    );
  }

  Future<void> contactViaWhatsApp(Clinic clinic) async {
    final message = Uri.encodeComponent(
      'Olá! Gostaria de saber mais sobre a ${clinic.name} para o cuidado do meu familiar.',
    );
    final uri = Uri.parse(
      'https://wa.me/${clinic.whatsappPhone}?text=$message',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);

    final guardian = _authStore.guardian;
    if (guardian == null) return;

    await _authService.markClinicContacted(
      guardianId: guardian.id,
      clinicId: clinic.id,
    );
    notifyListeners();
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
