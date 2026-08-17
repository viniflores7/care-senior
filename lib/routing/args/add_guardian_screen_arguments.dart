class AddGuardianScreenArguments {
  const AddGuardianScreenArguments({this.residentId});

  /// Quando informado, a tela cadastra um responsável a mais pra um idoso
  /// **já existente** (esconde os campos do idoso). Quando nulo, mantém o
  /// fluxo original: cadastra responsável + idoso juntos.
  final String? residentId;
}
