import 'package:care_senior_study/data/models/activity.dart';

class ActivityDetailScreenArguments {
  const ActivityDetailScreenArguments({
    required this.activity,
    required this.viewerRole,
    this.focusResidentId,
  });

  final Activity activity;
  final String viewerRole;

  /// Quando não nulo, restringe as ações de marcar presença ao idoso
  /// informado (agenda de um idoso específico). Quando nulo, a tela mostra
  /// todos os participantes da atividade (agenda da clínica).
  final String? focusResidentId;
}
