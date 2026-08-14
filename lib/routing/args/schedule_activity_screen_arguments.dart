class ScheduleActivityScreenArguments {
  const ScheduleActivityScreenArguments({
    required this.clinicId,
    this.preselectedResidentIds = const [],
  });

  final String clinicId;
  final List<String> preselectedResidentIds;
}
