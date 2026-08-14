class Guardian {
  const Guardian({
    required this.id,
    required this.name,
    required this.email,
    required this.residentIds,
    this.photoPath,
    this.cpf,
    this.contactedClinicIds = const [],
  });

  final String id;
  final String name;
  final String email;
  final List<String> residentIds;
  final String? photoPath;
  final String? cpf;

  /// Clínicas que o responsável já contatou (ex.: via WhatsApp) enquanto
  /// nenhum idoso seu está vinculado — usado pra tirar essas clínicas da
  /// lista de "buscar clínicas" e evitar contato duplicado.
  final List<String> contactedClinicIds;

  Guardian copyWith({
    String? name,
    String? cpf,
    String? photoPath,
    List<String>? contactedClinicIds,
  }) {
    return Guardian(
      id: id,
      name: name ?? this.name,
      email: email,
      residentIds: residentIds,
      photoPath: photoPath ?? this.photoPath,
      cpf: cpf ?? this.cpf,
      contactedClinicIds: contactedClinicIds ?? this.contactedClinicIds,
    );
  }
}
