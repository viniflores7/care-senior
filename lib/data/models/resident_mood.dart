/// Humor/temperamento geral do idoso — preenchido no cadastro (pelo
/// responsável ou pela equipe) para dar contexto de cuidado.
class ResidentMood {
  ResidentMood._();

  static const String cheerful = 'Alegre';
  static const String calm = 'Calmo(a)';
  static const String anxious = 'Ansioso(a)';
  static const String irritable = 'Irritadiço(a)';
  static const String sad = 'Triste';
  static const String confused = 'Confuso(a)';
  static const String variable = 'Variável';

  static const List<String> all = [
    cheerful,
    calm,
    anxious,
    irritable,
    sad,
    confused,
    variable,
  ];
}
