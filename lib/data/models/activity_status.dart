class ActivityStatus {
  ActivityStatus._();

  static const String pending = 'Pendente';
  static const String inProgress = 'Em andamento';
  static const String completed = 'Concluída';
  static const String late = 'Atrasada';
  static const String cancelled = 'Cancelada';
  static const String skipped = 'Pulada';

  /// Status em que a atividade ainda pode receber uma ação da equipe
  /// (iniciar, concluir ou pular).
  static const Set<String> open = {pending, inProgress, late};

  /// Status em que ainda faz sentido "iniciar" — quem já está em andamento
  /// ou terminou não entra aqui.
  static const Set<String> startable = {pending, late};
}
