/// Vínculo entre uma [Activity] e um idoso participante, com o status de
/// presença individual daquele idoso naquela atividade.
class ActivityParticipant {
  const ActivityParticipant({
    required this.residentId,
    required this.status,
    this.completedAt,
    this.notes,
    this.registeredBy,
    this.rating,
    this.comment,
  });

  final String residentId;
  final String status;
  final DateTime? completedAt;

  /// Motivo de ter sido pulada — visível ao responsável (é o que garante a
  /// ele saber por que algo não foi feito).
  final String? notes;

  /// Quem da equipe registrou o status. Guardado por consistência/auditoria
  /// no banco, mas **não deve ser exibido ao responsável** — só ao staff.
  final String? registeredBy;

  /// Nota de 1 a 5 dada pela equipe ao concluir. Visível ao responsável.
  final int? rating;

  /// Comentário livre dado ao concluir. Visível ao responsável, sem
  /// identificar quem escreveu (ver [registeredBy]).
  final String? comment;

  ActivityParticipant copyWith({
    String? status,
    DateTime? completedAt,
    String? notes,
    String? registeredBy,
    int? rating,
    String? comment,
  }) {
    return ActivityParticipant(
      residentId: residentId,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      registeredBy: registeredBy ?? this.registeredBy,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }
}
