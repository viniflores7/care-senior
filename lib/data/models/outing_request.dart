import 'package:care_senior_study/data/models/outing_request_status.dart';

/// Pedido do responsável para levar o idoso pra passar um período fora da
/// clínica (ex.: final de semana em família) — precisa de aprovação da
/// equipe antes de valer.
class OutingRequest {
  const OutingRequest({
    required this.id,
    required this.residentId,
    required this.guardianId,
    required this.departureAt,
    required this.returnAt,
    required this.createdAt,
    this.notes,
    this.status = OutingRequestStatus.pending,
    this.rejectionReason,
    this.respondedAt,
  });

  final String id;
  final String residentId;
  final String guardianId;
  final DateTime departureAt;
  final DateTime returnAt;
  final DateTime createdAt;

  /// Informações extras relevantes pra saída (destino, contato de
  /// emergência, medicação a levar etc.) — texto livre.
  final String? notes;

  final String status;

  /// Preenchido pela equipe só quando [status] é [OutingRequestStatus.rejected].
  final String? rejectionReason;

  final DateTime? respondedAt;

  OutingRequest copyWith({
    String? status,
    String? rejectionReason,
    DateTime? respondedAt,
  }) {
    return OutingRequest(
      id: id,
      residentId: residentId,
      guardianId: guardianId,
      departureAt: departureAt,
      returnAt: returnAt,
      createdAt: createdAt,
      notes: notes,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}
