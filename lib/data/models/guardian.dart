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

  /// Sentinela usada em [copyWith] pra diferenciar "campo não informado"
  /// de "campo explicitamente nulo" — sem isso, esvaziar o CPF na tela de
  /// Segurança e salvar não limpava o valor antigo.
  static const Object unset = Object();

  Guardian copyWith({
    String? name,
    Object? cpf = unset,
    Object? photoPath = unset,
    List<String>? contactedClinicIds,
  }) {
    return Guardian(
      id: id,
      name: name ?? this.name,
      email: email,
      residentIds: residentIds,
      photoPath: photoPath == unset ? this.photoPath : photoPath as String?,
      cpf: cpf == unset ? this.cpf : cpf as String?,
      contactedClinicIds: contactedClinicIds ?? this.contactedClinicIds,
    );
  }
}
