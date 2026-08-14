class Clinic {
  const Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.operatingHours,
    required this.activities,
    required this.responsiblePeople,
    required this.whatsappPhone,
    required this.latitude,
    required this.longitude,
    this.photoPath,
  });

  final String id;
  final String name;
  final String address;
  final String phone;
  final String operatingHours;
  final List<String> activities;
  final String responsiblePeople;
  final String whatsappPhone;
  final double latitude;
  final double longitude;
  final String? photoPath;
}
