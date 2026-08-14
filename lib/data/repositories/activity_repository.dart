import 'package:care_senior_study/data/mock/mock_data.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/data/models/activity_participant.dart';
import 'package:care_senior_study/data/models/activity_status.dart';
import 'package:care_senior_study/data/models/health_record.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivitiesByClinicId(String clinicId);

  Future<List<Activity>> getActivitiesByResidentId(String residentId);

  Future<Activity> startActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
  });

  /// Inicia de uma vez todos os participantes ainda não iniciados
  /// ([ActivityStatus.startable]) — evita ter que iniciar um a um.
  Future<Activity> startAllParticipants({
    required String activityId,
    required String registeredBy,
  });

  Future<Activity> completeActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
    int? rating,
    String? comment,
  });

  Future<Activity> skipActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
    String? reason,
  });

  Future<Activity> createActivity({
    required String clinicId,
    required List<String> residentIds,
    required String type,
    required String title,
    required DateTime scheduledTime,
    String? detail,
    String? photoPath,
    String? medicationId,
  });

  Future<List<HealthRecord>> getHealthRecordsByResidentId(String residentId);

  Future<List<HealthRecord>> getHealthRecordsByClinicId(
    List<String> residentIds,
  );

  Future<HealthRecord> addHealthRecord({
    required String residentId,
    required String type,
    required String value,
    required String recordedBy,
  });
}

class MockActivityRepository implements ActivityRepository {
  static const _latency = Duration(milliseconds: 300);

  final List<Activity> _activities = List.of(MockData.activities);
  final List<HealthRecord> _healthRecords = List.of(MockData.healthRecords);

  @override
  Future<List<Activity>> getActivitiesByClinicId(String clinicId) async {
    await Future.delayed(_latency);
    return _activities
        .where((activity) => activity.clinicId == clinicId)
        .toList();
  }

  @override
  Future<List<Activity>> getActivitiesByResidentId(String residentId) async {
    await Future.delayed(_latency);
    return _activities
        .where(
          (activity) => activity.participants.any(
            (participant) => participant.residentId == residentId,
          ),
        )
        .toList();
  }

  @override
  Future<Activity> startActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
  }) {
    return _updateParticipantStatus(
      activityId: activityId,
      residentId: residentId,
      status: ActivityStatus.inProgress,
      registeredBy: registeredBy,
    );
  }

  @override
  Future<Activity> startAllParticipants({
    required String activityId,
    required String registeredBy,
  }) async {
    await Future.delayed(_latency);
    final index = _activities.indexWhere(
      (activity) => activity.id == activityId,
    );
    if (index == -1) {
      throw StateError('Atividade não encontrada: $activityId');
    }

    var activity = _activities[index];
    for (final participant in activity.participants) {
      if (!ActivityStatus.startable.contains(participant.status)) continue;
      activity = activity.withParticipant(
        participant.residentId,
        participant.copyWith(
          status: ActivityStatus.inProgress,
          completedAt: DateTime.now(),
          registeredBy: registeredBy,
        ),
      );
    }
    _activities[index] = activity;
    return activity;
  }

  @override
  Future<Activity> completeActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
    int? rating,
    String? comment,
  }) {
    return _updateParticipantStatus(
      activityId: activityId,
      residentId: residentId,
      status: ActivityStatus.completed,
      registeredBy: registeredBy,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<Activity> skipActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
    String? reason,
  }) {
    return _updateParticipantStatus(
      activityId: activityId,
      residentId: residentId,
      status: ActivityStatus.skipped,
      registeredBy: registeredBy,
      notes: reason,
    );
  }

  @override
  Future<Activity> createActivity({
    required String clinicId,
    required List<String> residentIds,
    required String type,
    required String title,
    required DateTime scheduledTime,
    String? detail,
    String? photoPath,
    String? medicationId,
  }) async {
    await Future.delayed(_latency);
    final activity = Activity(
      id: 'activity-${_activities.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      clinicId: clinicId,
      type: type,
      title: title,
      scheduledTime: scheduledTime,
      participants: [
        for (final residentId in residentIds)
          ActivityParticipant(
            residentId: residentId,
            status: ActivityStatus.pending,
          ),
      ],
      detail: detail,
      photoPath: photoPath,
      medicationId: medicationId,
    );
    _activities.add(activity);
    return activity;
  }

  Future<Activity> _updateParticipantStatus({
    required String activityId,
    required String residentId,
    required String status,
    required String registeredBy,
    String? notes,
    int? rating,
    String? comment,
  }) async {
    await Future.delayed(_latency);
    final index = _activities.indexWhere(
      (activity) => activity.id == activityId,
    );
    if (index == -1) {
      throw StateError('Atividade não encontrada: $activityId');
    }

    final activity = _activities[index];
    final participant = activity.participantFor(residentId);
    if (participant == null) {
      throw StateError(
        'Idoso $residentId não participa da atividade $activityId',
      );
    }

    final updated = activity.withParticipant(
      residentId,
      participant.copyWith(
        status: status,
        completedAt: DateTime.now(),
        notes: notes,
        registeredBy: registeredBy,
        rating: rating,
        comment: comment,
      ),
    );
    _activities[index] = updated;
    return updated;
  }

  @override
  Future<List<HealthRecord>> getHealthRecordsByResidentId(
    String residentId,
  ) async {
    await Future.delayed(_latency);
    return _healthRecords
        .where((record) => record.residentId == residentId)
        .toList();
  }

  @override
  Future<List<HealthRecord>> getHealthRecordsByClinicId(
    List<String> residentIds,
  ) async {
    await Future.delayed(_latency);
    return _healthRecords
        .where((record) => residentIds.contains(record.residentId))
        .toList();
  }

  @override
  Future<HealthRecord> addHealthRecord({
    required String residentId,
    required String type,
    required String value,
    required String recordedBy,
  }) async {
    await Future.delayed(_latency);
    final record = HealthRecord(
      id: 'health-${_healthRecords.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      residentId: residentId,
      type: type,
      value: value,
      recordedAt: DateTime.now(),
      recordedBy: recordedBy,
    );
    _healthRecords.add(record);
    return record;
  }
}
