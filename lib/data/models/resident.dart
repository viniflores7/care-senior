class Resident {
  const Resident({
    required this.id,
    required this.name,
    required this.age,
    required this.healthNotes,
    this.clinicId,
    this.roomNumber,
    this.mood,
    this.peculiarities,
    this.photoPath,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  final String id;
  final String name;
  final int age;
  final String healthNotes;

  /// Nulo enquanto o idoso não estiver vinculado a nenhuma clínica — caso
  /// de um responsável que se cadastrou sozinho e ainda não fechou com
  /// nenhuma instituição.
  final String? clinicId;

  /// Só existe depois que uma clínica vincula o idoso (ver [clinicId]).
  final String? roomNumber;

  /// Humor/temperamento geral — ver `ResidentMood`.
  final String? mood;

  /// Preferências, manias, gatilhos — texto livre.
  final String? peculiarities;

  final String? photoPath;

  /// Quem a equipe deve acionar em uma emergência — nome e telefone livres.
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  bool get isLinkedToClinic => clinicId != null;

  /// Sentinela usada em [copyWith] (e propagada pelo `ResidentRepository`)
  /// pra diferenciar "campo não informado" (mantém o valor atual) de
  /// "campo explicitamente nulo" (limpa o campo) — sem isso, um `null`
  /// passado de propósito pra esvaziar `peculiarities`/`emergencyContact*`
  /// era indistinguível de "não estou mexendo nesse campo" e o valor
  /// antigo nunca era limpo.
  static const Object unset = Object();

  /// [clinicId]/[roomNumber] aceitam ser preenchidos aqui para o fluxo de
  /// aceite de vínculo (ver `AuthService.acceptLinkRequest`), quando o
  /// idoso sai de "sem clínica" para vinculado.
  Resident copyWith({
    Object? name = unset,
    Object? age = unset,
    Object? healthNotes = unset,
    Object? clinicId = unset,
    Object? roomNumber = unset,
    Object? mood = unset,
    Object? peculiarities = unset,
    Object? photoPath = unset,
    Object? emergencyContactName = unset,
    Object? emergencyContactPhone = unset,
  }) {
    return Resident(
      id: id,
      name: name == unset ? this.name : name as String,
      age: age == unset ? this.age : age as int,
      healthNotes: healthNotes == unset ? this.healthNotes : healthNotes as String,
      clinicId: clinicId == unset ? this.clinicId : clinicId as String?,
      roomNumber: roomNumber == unset ? this.roomNumber : roomNumber as String?,
      mood: mood == unset ? this.mood : mood as String?,
      peculiarities: peculiarities == unset
          ? this.peculiarities
          : peculiarities as String?,
      photoPath: photoPath == unset ? this.photoPath : photoPath as String?,
      emergencyContactName: emergencyContactName == unset
          ? this.emergencyContactName
          : emergencyContactName as String?,
      emergencyContactPhone: emergencyContactPhone == unset
          ? this.emergencyContactPhone
          : emergencyContactPhone as String?,
    );
  }

  /// Reverte o idoso pro estado "sem clínica" (igual antes de qualquer
  /// vínculo) — usado ao desvincular/dar baixa. Não dá pra fazer isso via
  /// [copyWith], já que `clinicId`/`roomNumber` precisam ser zerados de
  /// verdade, não só "mantidos quando não informados".
  Resident discharge() {
    return Resident(
      id: id,
      name: name,
      age: age,
      healthNotes: healthNotes,
      mood: mood,
      peculiarities: peculiarities,
      photoPath: photoPath,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
    );
  }
}
