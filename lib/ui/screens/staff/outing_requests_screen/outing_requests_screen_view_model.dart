import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/guardian.dart';
import 'package:care_senior_study/data/models/outing_request.dart';
import 'package:care_senior_study/data/models/outing_request_status.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/services/outing_request_service.dart';
import 'package:care_senior_study/services/resident_service.dart';
import 'package:care_senior_study/ui/screens/staff/outing_requests_screen/widgets/outing_reject_sheet.dart';

/// Item pronto pra exibição: a solicitação + o idoso e o responsável já
/// resolvidos, pra tela não precisar cruzar listas.
class StaffOutingRequestItem {
  const StaffOutingRequestItem({
    required this.request,
    required this.resident,
    required this.guardian,
  });

  final OutingRequest request;
  final Resident resident;
  final Guardian? guardian;
}

/// Fila de saídas pendentes de aprovação da clínica do colaborador logado.
class OutingRequestsScreenViewModel extends ChangeNotifier {
  final _outingRequestService = GetIt.I<OutingRequestService>();
  final _residentService = GetIt.I<ResidentService>();
  final _authService = GetIt.I<AuthService>();
  final _authStore = GetIt.I<AuthStore>();

  List<StaffOutingRequestItem> _items = [];
  String _query = '';
  bool isLoading = true;

  List<StaffOutingRequestItem> get items {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _items;

    return _items.where((item) {
      if (item.resident.name.toLowerCase().contains(query)) return true;
      return item.guardian?.name.toLowerCase().contains(query) ?? false;
    }).toList();
  }

  bool get hasAnyRequest => _items.isNotEmpty;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    final clinicId = _authStore.staff?.clinicId;
    if (clinicId == null) {
      _items = [];
      isLoading = false;
      notifyListeners();
      return;
    }

    final residents = await _residentService.getResidentsForClinic(clinicId);
    final residentById = {for (final r in residents) r.id: r};
    final requests = await _outingRequestService.getRequestsByResidentIds(
      residentById.keys.toList(),
    );

    final items = <StaffOutingRequestItem>[];
    for (final request in requests) {
      if (request.status != OutingRequestStatus.pending) continue;
      final resident = residentById[request.residentId];
      if (resident == null) continue;
      final guardian = await _authService.getGuardianById(request.guardianId);
      items.add(
        StaffOutingRequestItem(
          request: request,
          resident: resident,
          guardian: guardian,
        ),
      );
    }
    _items = items;

    isLoading = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> approve(OutingRequest request) async {
    await _outingRequestService.respondToRequest(
      id: request.id,
      approve: true,
    );
    await loadData();
  }

  Future<void> reject(BuildContext context, OutingRequest request) async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const OutingRejectSheet(),
    );
    if (reason == null) return;

    await _outingRequestService.respondToRequest(
      id: request.id,
      approve: false,
      rejectionReason: reason,
    );
    await loadData();
  }
}
