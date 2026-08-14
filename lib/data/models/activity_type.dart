class ActivityType {
  ActivityType._();

  static const String medication = 'Medicação';
  static const String meal = 'Refeição';
  static const String physicalActivity = 'Atividade física';
  static const String socialGathering = 'Confraternização';
  static const String vitalSigns = 'Sinais vitais';
  static const String hygiene = 'Higiene';
  static const String sleep = 'Sono';
  static const String other = 'Outros';

  static const List<String> all = [
    medication,
    meal,
    physicalActivity,
    socialGathering,
    vitalSigns,
    hygiene,
    sleep,
    other,
  ];
}
