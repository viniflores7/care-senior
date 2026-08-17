class StaffMember {
  const StaffMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.clinicId,
    this.photoPath,
    this.cpf,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String clinicId;
  final String? photoPath;
  final String? cpf;

  /// Sentinela usada em [copyWith] pra diferenciar "campo não informado"
  /// de "campo explicitamente nulo" — sem isso, esvaziar o CPF na tela de
  /// Segurança e salvar não limpava o valor antigo.
  static const Object unset = Object();

  StaffMember copyWith({
    String? name,
    Object? cpf = unset,
    Object? photoPath = unset,
  }) {
    return StaffMember(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      clinicId: clinicId,
      photoPath: photoPath == unset ? this.photoPath : photoPath as String?,
      cpf: cpf == unset ? this.cpf : cpf as String?,
    );
  }
}
