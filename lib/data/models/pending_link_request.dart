import 'package:care_senior_study/data/models/guardian.dart';
import 'package:care_senior_study/data/models/resident.dart';

/// Vínculo pendente de confirmação pela equipe: um responsável que já
/// contatou a clínica e o(s) idoso(s) dele ainda sem `clinicId`/`roomNumber`
/// preenchidos. Ver `AuthService.getPendingLinkRequests`.
class PendingLinkRequest {
  const PendingLinkRequest({required this.guardian, required this.residents});

  final Guardian guardian;

  /// Só os idosos deste responsável ainda não vinculados a nenhuma clínica.
  final List<Resident> residents;
}
