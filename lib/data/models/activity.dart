import 'package:care_senior_study/data/models/activity_participant.dart';
import 'package:care_senior_study/data/models/activity_status.dart';

class Activity {
  const Activity({
    required this.id,
    required this.clinicId,
    required this.type,
    required this.title,
    required this.scheduledTime,
    required this.participants,
    this.detail,
    this.photoPath,
    this.medicationId,
  });

  final String id;
  final String clinicId;
  final String type;
  final String title;
  final DateTime scheduledTime;
  final List<ActivityParticipant> participants;

  /// Complemento livre cujo significado varia por categoria (ex.: qual
  /// atividade física, descrição da confraternização/outros).
  final String? detail;

  /// Caminho local de uma foto anexada (ex.: comprovante de medicação).
  final String? photoPath;

  /// Quando [type] é [ActivityType.medication], referencia o registro
  /// estruturado (dosagem, via, prescritor) em [Medication]. O horário
  /// agendado desta atividade continua sendo a própria [scheduledTime].
  final String? medicationId;

  ActivityParticipant? participantFor(String residentId) {
    for (final participant in participants) {
      if (participant.residentId == residentId) return participant;
    }
    return null;
  }

  int get totalCount => participants.length;

  int get completedCount => participants
      .where((participant) => participant.status == ActivityStatus.completed)
      .length;

  /// Retorna uma cópia da atividade com o participante de [residentId]
  /// substituído por [participant].
  Activity withParticipant(String residentId, ActivityParticipant participant) {
    return Activity(
      id: id,
      clinicId: clinicId,
      type: type,
      title: title,
      scheduledTime: scheduledTime,
      participants: [
        for (final current in participants)
          if (current.residentId == residentId) participant else current,
      ],
      detail: detail,
      photoPath: photoPath,
      medicationId: medicationId,
    );
  }
}
