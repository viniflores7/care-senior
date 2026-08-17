/// Cargo do colaborador dentro da clínica — define quais ações
/// administrativas ele pode realizar, além do texto livre exibido hoje.
class StaffRole {
  StaffRole._();

  static const String coordinator = 'Coordenadora';
  static const String nurse = 'Enfermeira';
  static const String caregiver = 'Cuidador';

  static const List<String> all = [coordinator, nurse, caregiver];

  /// Só coordenadoras e enfermeiras aprovam/recusam solicitações (vínculo,
  /// saída) e desvinculam idosos da clínica — ações administrativas ou
  /// sensíveis que um cuidador não deve realizar sozinho.
  static bool canManageRequests(String role) =>
      role == coordinator || role == nurse;
}
