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

  StaffMember copyWith({String? name, String? cpf, String? photoPath}) {
    return StaffMember(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      clinicId: clinicId,
      photoPath: photoPath ?? this.photoPath,
      cpf: cpf ?? this.cpf,
    );
  }
}
