/// Prescrição estruturada de um medicamento de um idoso — dado sensível,
/// mantido separado da agenda: uma [Medication] é a "receita"; cada dose
/// agendada é uma [Activity] do tipo `medication` que referencia esta
/// prescrição via `medicationId`.
class Medication {
  const Medication({
    required this.id,
    required this.residentId,
    required this.name,
    required this.dosage,
    required this.form,
    required this.frequency,
    required this.startDate,
    this.instructions,
    this.prescribedBy,
    this.endDate,
    this.active = true,
  });

  final String id;
  final String residentId;

  /// Nome do medicamento (ex.: "Losartana").
  final String name;

  /// Ex.: "50mg".
  final String dosage;

  /// Ver [MedicationForm].
  final String form;

  /// Ex.: "A cada 8 horas", "1x ao dia, em jejum".
  final String frequency;

  final DateTime startDate;

  /// Cuidados/observações da prescrição (ex.: "tomar após o café").
  final String? instructions;

  /// Médico ou profissional que prescreveu.
  final String? prescribedBy;

  /// Nulo enquanto o tratamento for contínuo/sem previsão de término.
  final DateTime? endDate;

  final bool active;

  Medication copyWith({bool? active, DateTime? endDate}) {
    return Medication(
      id: id,
      residentId: residentId,
      name: name,
      dosage: dosage,
      form: form,
      frequency: frequency,
      startDate: startDate,
      instructions: instructions,
      prescribedBy: prescribedBy,
      endDate: endDate ?? this.endDate,
      active: active ?? this.active,
    );
  }
}
