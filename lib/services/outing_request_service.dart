import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/outing_request.dart';
import 'package:care_senior_study/data/repositories/outing_request_repository.dart';

class OutingRequestService {
  final _outingRequestRepository = GetIt.I<OutingRequestRepository>();

  Future<List<OutingRequest>> getRequestsByResidentIds(
    List<String> residentIds,
  ) {
    return _outingRequestRepository.getRequestsByResidentIds(residentIds);
  }

  Future<OutingRequest> createRequest({
    required String residentId,
    required String guardianId,
    required DateTime departureAt,
    required DateTime returnAt,
    String? notes,
  }) {
    return _outingRequestRepository.createRequest(
      residentId: residentId,
      guardianId: guardianId,
      departureAt: departureAt,
      returnAt: returnAt,
      notes: notes,
    );
  }

  Future<OutingRequest> respondToRequest({
    required String id,
    required bool approve,
    String? rejectionReason,
  }) {
    return _outingRequestRepository.respondToRequest(
      id: id,
      approve: approve,
      rejectionReason: rejectionReason,
    );
  }
}
