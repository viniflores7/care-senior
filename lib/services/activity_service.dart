import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/data/models/health_record.dart';
import 'package:care_senior_study/data/repositories/activity_repository.dart';

class ActivityService {
  final _activityRepository = GetIt.I<ActivityRepository>();

  Future<List<Activity>> getActivitiesByClinicId(String clinicId) {
    return _activityRepository.getActivitiesByClinicId(clinicId);
  }

  Future<List<Activity>> getActivitiesByResidentId(String residentId) {
    return _activityRepository.getActivitiesByResidentId(residentId);
  }

  Future<Activity> startActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
  }) {
    return _activityRepository.startActivity(
      activityId: activityId,
      residentId: residentId,
      registeredBy: registeredBy,
    );
  }

  Future<Activity> startAllParticipants({
    required String activityId,
    required String registeredBy,
  }) {
    return _activityRepository.startAllParticipants(
      activityId: activityId,
      registeredBy: registeredBy,
    );
  }

  Future<Activity> completeActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
    int? rating,
    String? comment,
  }) {
    return _activityRepository.completeActivity(
      activityId: activityId,
      residentId: residentId,
      registeredBy: registeredBy,
      rating: rating,
      comment: comment,
    );
  }

  Future<Activity> skipActivity({
    required String activityId,
    required String residentId,
    required String registeredBy,
    String? reason,
  }) {
    return _activityRepository.skipActivity(
      activityId: activityId,
      residentId: residentId,
      registeredBy: registeredBy,
      reason: reason,
    );
  }

  Future<Activity> createActivity({
    required String clinicId,
    required List<String> residentIds,
    required String type,
    required String title,
    required DateTime scheduledTime,
    String? detail,
    String? photoPath,
    String? medicationId,
  }) {
    return _activityRepository.createActivity(
      clinicId: clinicId,
      residentIds: residentIds,
      type: type,
      title: title,
      scheduledTime: scheduledTime,
      detail: detail,
      photoPath: photoPath,
      medicationId: medicationId,
    );
  }

  Future<List<HealthRecord>> getHealthRecordsByResidentId(String residentId) {
    return _activityRepository.getHealthRecordsByResidentId(residentId);
  }

  Future<List<HealthRecord>> getHealthRecordsByClinicId(
    List<String> residentIds,
  ) {
    return _activityRepository.getHealthRecordsByClinicId(residentIds);
  }

  Future<HealthRecord> addHealthRecord({
    required String residentId,
    required String type,
    required String value,
    required String recordedBy,
  }) {
    return _activityRepository.addHealthRecord(
      residentId: residentId,
      type: type,
      value: value,
      recordedBy: recordedBy,
    );
  }
}
