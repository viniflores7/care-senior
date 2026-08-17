import 'package:care_senior_study/data/models/resident.dart';

class OutingRequestFormScreenArguments {
  const OutingRequestFormScreenArguments({required this.residents});

  /// Idosos do responsável logado — quando há mais de um, a tela pede pra
  /// escolher qual deles vai sair.
  final List<Resident> residents;
}
