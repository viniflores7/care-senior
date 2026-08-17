import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/pending_link_request.dart';
import 'package:care_senior_study/notifiers/auth_store.dart';
import 'package:care_senior_study/routing/args/link_request_review_screen_arguments.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/services/auth_service.dart';
import 'package:care_senior_study/utils/navigator.dart';

/// Fila de responsáveis que já contataram a clínica e aguardam a equipe
/// aceitar o vínculo do(s) idoso(s) — busca por responsável ou idoso.
class LinkRequestsScreenViewModel extends ChangeNotifier {
  final _authService = GetIt.I<AuthService>();
  final _authStore = GetIt.I<AuthStore>();

  List<PendingLinkRequest> _requests = [];
  String _query = '';
  bool isLoading = true;

  List<PendingLinkRequest> get requests {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _requests;

    return _requests.where((request) {
      if (request.guardian.name.toLowerCase().contains(query)) return true;
      return request.residents.any(
        (resident) => resident.name.toLowerCase().contains(query),
      );
    }).toList();
  }

  bool get hasAnyRequest => _requests.isNotEmpty;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    final clinicId = _authStore.staff?.clinicId;
    _requests = clinicId == null
        ? []
        : await _authService.getPendingLinkRequests(clinicId);

    isLoading = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> navigateToReview(
    BuildContext context,
    PendingLinkRequest request,
  ) async {
    final accepted = await navigator(context).pushNamed(
      Routes.staffLinkRequestReviewScreen,
      arguments: LinkRequestReviewScreenArguments(request: request),
    );
    if (accepted == true) {
      await loadData();
    }
  }
}
