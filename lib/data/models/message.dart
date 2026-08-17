/// Recado pontual trocado entre a equipe da clínica e o responsável sobre um
/// idoso específico — não é um chat em tempo real, só uma lista simples
/// (ex.: "vou chegar atrasado na visita", "hoje ele não quis almoçar").
class Message {
  const Message({
    required this.id,
    required this.residentId,
    required this.senderRole,
    required this.senderName,
    required this.text,
    required this.sentAt,
  });

  final String id;
  final String residentId;

  /// `staff` ou `guardian` — ver `ViewerRole`.
  final String senderRole;
  final String senderName;
  final String text;
  final DateTime sentAt;
}
