/// Rascunho de medicamento capturado durante um cadastro de idoso (seja
/// pelo responsável ou pela equipe) — antes de o idoso ter um `id` real.
/// Só vira um [Medication] persistido depois que o cadastro é concluído.
class MedicationDraft {
  const MedicationDraft({
    required this.name,
    required this.dosage,
    required this.form,
    required this.frequency,
    this.instructions,
    this.prescribedBy,
  });

  final String name;
  final String dosage;
  final String form;
  final String frequency;
  final String? instructions;
  final String? prescribedBy;
}
