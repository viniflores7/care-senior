import 'package:care_senior_study/data/mock/mock_data.dart';
import 'package:care_senior_study/data/models/outing_request.dart';
import 'package:care_senior_study/data/models/outing_request_status.dart';

abstract class OutingRequestRepository {
  /// Todas as solicitações (qualquer status) dos idosos em [residentIds] —
  /// usado tanto pelo responsável (histórico dos seus idosos) quanto pela
  /// equipe (fila da clínica, filtrada por status na camada de serviço).
  Future<List<OutingRequest>> getRequestsByResidentIds(
    List<String> residentIds,
  );

  Future<OutingRequest> createRequest({
    required String residentId,
    required String guardianId,
    required DateTime departureAt,
    required DateTime returnAt,
    String? notes,
  });

  Future<OutingRequest> respondToRequest({
    required String id,
    required bool approve,
    String? rejectionReason,
  });
}

class MockOutingRequestRepository implements OutingRequestRepository {
  static const _latency = Duration(milliseconds: 300);

  final List<OutingRequest> _requests = List.of(MockData.outingRequests);

  @override
  Future<List<OutingRequest>> getRequestsByResidentIds(
    List<String> residentIds,
  ) async {
    await Future.delayed(_latency);
    final requests = _requests
        .where((request) => residentIds.contains(request.residentId))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return requests;
  }

  @override
  Future<OutingRequest> createRequest({
    required String residentId,
    required String guardianId,
    required DateTime departureAt,
    required DateTime returnAt,
    String? notes,
  }) async {
    await Future.delayed(_latency);
    final request = OutingRequest(
      id: 'outing-${_requests.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      residentId: residentId,
      guardianId: guardianId,
      departureAt: departureAt,
      returnAt: returnAt,
      createdAt: DateTime.now(),
      notes: notes,
    );
    _requests.add(request);
    return request;
  }

  @override
  Future<OutingRequest> respondToRequest({
    required String id,
    required bool approve,
    String? rejectionReason,
  }) async {
    await Future.delayed(_latency);
    final index = _requests.indexWhere((request) => request.id == id);
    if (index == -1) {
      throw StateError('Solicitação de saída não encontrada: $id');
    }

    final updated = _requests[index].copyWith(
      status: approve
          ? OutingRequestStatus.approved
          : OutingRequestStatus.rejected,
      rejectionReason: approve ? null : rejectionReason,
      respondedAt: DateTime.now(),
    );
    _requests[index] = updated;
    return updated;
  }
}
