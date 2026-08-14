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

  bool get isLinkedToClinic => clinicId != null;

  Resident copyWith({
    String? name,
    int? age,
    String? healthNotes,
    String? clinicId,
    String? roomNumber,
    String? mood,
    String? peculiarities,
    String? photoPath,
  }) {
    return Resident(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      healthNotes: healthNotes ?? this.healthNotes,
      clinicId: clinicId ?? this.clinicId,
      roomNumber: roomNumber ?? this.roomNumber,
      mood: mood ?? this.mood,
      peculiarities: peculiarities ?? this.peculiarities,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
