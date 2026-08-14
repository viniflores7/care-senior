class HealthRecord {
  const HealthRecord({
    required this.id,
    required this.residentId,
    required this.type,
    required this.value,
    required this.recordedAt,
    required this.recordedBy,
  });

  final String id;
  final String residentId;
  final String type;
  final String value;
  final DateTime recordedAt;
  final String recordedBy;
}
