/// Via/apresentação de um [Medication] — como ele é administrado.
class MedicationForm {
  MedicationForm._();

  static const String tablet = 'Comprimido';
  static const String liquid = 'Líquido';
  static const String injection = 'Injetável';
  static const String cream = 'Pomada/Creme';
  static const String other = 'Outro';

  static const List<String> all = [tablet, liquid, injection, cream, other];
}
