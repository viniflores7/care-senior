import 'package:care_senior_study/data/models/activity.dart';
import 'package:care_senior_study/data/models/activity_participant.dart';
import 'package:care_senior_study/data/models/activity_status.dart';
import 'package:care_senior_study/data/models/activity_type.dart';
import 'package:care_senior_study/data/models/app_notification.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/guardian.dart';
import 'package:care_senior_study/data/models/health_record.dart';
import 'package:care_senior_study/data/models/medication.dart';
import 'package:care_senior_study/data/models/medication_form.dart';
import 'package:care_senior_study/data/models/notification_type.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/data/models/resident_mood.dart';
import 'package:care_senior_study/data/models/staff_member.dart';
import 'package:care_senior_study/routing/args/viewer_role.dart';

/// Fonte única de dados falsos usada pelos repositórios mock.
/// Substitua os repositórios por implementações reais (API) mantendo a
/// mesma interface para remover a dependência deste arquivo.
class MockData {
  MockData._();

  static DateTime _today(int hour, int minute) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  static DateTime _tomorrow(int hour, int minute) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);
  }

  static final List<Clinic> clinics = [
    const Clinic(
      id: 'clinic-1',
      name: 'Residencial Vida Plena',
      address: 'Rua das Acácias, 120 - Águas Claras, Brasília - DF',
      phone: '(61) 3333-1010',
      operatingHours: 'Segunda a domingo, 24 horas (visitas das 14h às 18h)',
      activities: [
        'Fisioterapia',
        'Atividades recreativas',
        'Acompanhamento nutricional',
      ],
      responsiblePeople: 'Enfermeira Juliana Martins (responsável técnica)',
      whatsappPhone: '5561933331010',
      latitude: -15.8375,
      longitude: -48.0281,
    ),
    const Clinic(
      id: 'clinic-2',
      name: 'Clínica Bem Viver',
      address: 'Av. das Palmeiras, 45 - Taguatinga, Brasília - DF',
      phone: '(61) 3333-2020',
      operatingHours: 'Segunda a domingo, 24 horas (visitas das 10h às 20h)',
      activities: ['Fisioterapia', 'Terapia ocupacional', 'Higiene assistida'],
      responsiblePeople: 'Coordenadora Ana Paula (gestão geral)',
      whatsappPhone: '5561933332020',
      latitude: -15.8330,
      longitude: -48.0570,
    ),
    const Clinic(
      id: 'clinic-3',
      name: 'Lar Recanto Feliz',
      address: 'Quadra 7, Lote 3 - Sobradinho, Brasília - DF',
      phone: '(61) 3333-3030',
      operatingHours: 'Segunda a sábado, 7h às 19h',
      activities: [
        'Atividades recreativas',
        'Acompanhamento nutricional',
        'Fisioterapia',
      ],
      responsiblePeople: 'Coordenadora Ana Paula (gestão geral)',
      whatsappPhone: '5561933333030',
      latitude: -15.6530,
      longitude: -47.7970,
    ),
  ];

  static final List<Resident> residents = [
    const Resident(
      id: 'resident-1',
      name: 'Maria Aparecida Souza',
      age: 82,
      clinicId: 'clinic-1',
      roomNumber: '12B',
      healthNotes: 'Hipertensão controlada. Mobilidade reduzida.',
    ),
    const Resident(
      id: 'resident-2',
      name: 'José Carlos Pereira',
      age: 78,
      clinicId: 'clinic-1',
      roomNumber: '14A',
      healthNotes: 'Diabetes tipo 2. Faz fisioterapia semanal.',
    ),
    const Resident(
      id: 'resident-3',
      name: 'Antônia Ferreira Lima',
      age: 91,
      clinicId: 'clinic-2',
      roomNumber: '03',
      healthNotes: 'Início de quadro de demência leve.',
    ),
    const Resident(
      id: 'resident-4',
      name: 'Sebastião Rodrigues',
      age: 85,
      clinicId: 'clinic-2',
      roomNumber: '07',
      healthNotes: 'Recuperação de fratura no quadril.',
    ),
    const Resident(
      id: 'resident-5',
      name: 'Otávio Nascimento',
      age: 74,
      clinicId: 'clinic-3',
      roomNumber: '21',
      healthNotes:
          'Sem restrições relevantes. Independente para atividades básicas.',
    ),
    const Resident(
      id: 'resident-6',
      name: 'Rosa Maria Duarte',
      age: 88,
      clinicId: 'clinic-3',
      roomNumber: '18',
      healthNotes: 'Cardiopatia leve. Acompanhamento nutricional.',
    ),
    // Autocadastrado pelo responsável (guardian-3), ainda sem clínica
    // vinculada — demonstra o fluxo de cadastro antes do contato.
    const Resident(
      id: 'resident-7',
      name: 'Benedito Nogueira',
      age: 80,
      healthNotes: 'Hipertensão leve, controlada com medicação diária.',
      mood: ResidentMood.calm,
      peculiarities: 'Não gosta de barulho alto. Prefere refeições cedo.',
    ),
  ];

  static final List<Guardian> guardians = [
    const Guardian(
      id: 'guardian-1',
      name: 'Fernanda Costa',
      email: 'familia@teste.com',
      residentIds: ['resident-1', 'resident-2'],
    ),
    const Guardian(
      id: 'guardian-2',
      name: 'Ricardo Almeida',
      email: 'ricardo@teste.com',
      residentIds: ['resident-5'],
    ),
    const Guardian(
      id: 'guardian-3',
      name: 'Camila Torres',
      email: 'novo@teste.com',
      residentIds: ['resident-7'],
    ),
  ];

  static final List<StaffMember> staffMembers = [
    const StaffMember(
      id: 'staff-1',
      name: 'Enfermeira Juliana Martins',
      email: 'equipe@clinica.com',
      role: 'Enfermeira',
      clinicId: 'clinic-1',
    ),
    const StaffMember(
      id: 'staff-2',
      name: 'Cuidador Pedro Henrique',
      email: 'pedro@clinicabemviver.com',
      role: 'Cuidador',
      clinicId: 'clinic-2',
    ),
    const StaffMember(
      id: 'staff-3',
      name: 'Coordenadora Ana Paula',
      email: 'anapaula@recantofeliz.com',
      role: 'Coordenadora',
      clinicId: 'clinic-3',
    ),
  ];

  static final List<Activity> activities = [
    // Clínica 1 — Maria Aparecida (resident-1) e José Carlos (resident-2)
    Activity(
      id: 'activity-1',
      clinicId: 'clinic-1',
      type: ActivityType.medication,
      title: 'Losartana 50mg',
      scheduledTime: _today(8, 0),
      medicationId: 'medication-1',
      participants: [
        ActivityParticipant(
          residentId: 'resident-1',
          status: ActivityStatus.completed,
          completedAt: _today(8, 5),
          registeredBy: 'Enfermeira Juliana Martins',
          rating: 5,
          comment: 'Tomou sem resistência, bem-humorada.',
        ),
      ],
    ),
    // TODO(usuário): trocar por um caminho de foto real quando quiser testar
    // o preview de anexo de medicação com uma imagem já existente.
    Activity(
      id: 'activity-2',
      clinicId: 'clinic-1',
      type: ActivityType.meal,
      title: 'Café da manhã',
      scheduledTime: _today(8, 30),
      participants: [
        ActivityParticipant(
          residentId: 'resident-1',
          status: ActivityStatus.completed,
          completedAt: _today(8, 40),
          registeredBy: 'Enfermeira Juliana Martins',
        ),
      ],
    ),
    // Atividade com múltiplos participantes: os dois idosos da clínica-1.
    Activity(
      id: 'activity-3',
      clinicId: 'clinic-1',
      type: ActivityType.socialGathering,
      title: 'Roda de música',
      scheduledTime: _today(15, 0),
      detail: 'Roda de música com violão e cantoria em grupo.',
      participants: [
        ActivityParticipant(
          residentId: 'resident-1',
          status: ActivityStatus.pending,
        ),
        ActivityParticipant(
          residentId: 'resident-2',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    Activity(
      id: 'activity-4',
      clinicId: 'clinic-1',
      type: ActivityType.medication,
      title: 'Metformina 850mg',
      scheduledTime: _today(7, 30),
      medicationId: 'medication-2',
      participants: [
        ActivityParticipant(
          residentId: 'resident-2',
          status: ActivityStatus.late,
        ),
      ],
    ),
    Activity(
      id: 'activity-5',
      clinicId: 'clinic-1',
      type: ActivityType.physicalActivity,
      title: 'Sessão de fisioterapia',
      scheduledTime: _today(10, 0),
      detail: 'Fisioterapia motora',
      participants: [
        ActivityParticipant(
          residentId: 'resident-2',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    Activity(
      id: 'activity-13',
      clinicId: 'clinic-1',
      type: ActivityType.vitalSigns,
      title: 'Aferição de pressão',
      scheduledTime: _tomorrow(9, 0),
      participants: [
        ActivityParticipant(
          residentId: 'resident-1',
          status: ActivityStatus.pending,
        ),
        ActivityParticipant(
          residentId: 'resident-2',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    // Clínica 2 — Antônia (resident-3) e Sebastião (resident-4)
    Activity(
      id: 'activity-6',
      clinicId: 'clinic-2',
      type: ActivityType.vitalSigns,
      title: 'Aferição de pressão',
      scheduledTime: _today(9, 0),
      participants: [
        ActivityParticipant(
          residentId: 'resident-3',
          status: ActivityStatus.completed,
          completedAt: _today(9, 2),
          registeredBy: 'Cuidador Pedro Henrique',
        ),
      ],
    ),
    Activity(
      id: 'activity-7',
      clinicId: 'clinic-2',
      type: ActivityType.hygiene,
      title: 'Banho assistido',
      scheduledTime: _today(11, 0),
      participants: [
        ActivityParticipant(
          residentId: 'resident-3',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    Activity(
      id: 'activity-8',
      clinicId: 'clinic-2',
      type: ActivityType.physicalActivity,
      title: 'Fisioterapia de quadril',
      scheduledTime: _today(14, 0),
      detail: 'Fisioterapia de recuperação do quadril',
      participants: [
        ActivityParticipant(
          residentId: 'resident-4',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    Activity(
      id: 'activity-14',
      clinicId: 'clinic-2',
      type: ActivityType.socialGathering,
      title: 'Confraternização da tarde',
      scheduledTime: _tomorrow(16, 0),
      detail: 'Café da tarde com os residentes.',
      participants: [
        ActivityParticipant(
          residentId: 'resident-3',
          status: ActivityStatus.pending,
        ),
        ActivityParticipant(
          residentId: 'resident-4',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    // Clínica 3 — Otávio (resident-5) e Rosa Maria (resident-6)
    // Atividade com múltiplos participantes: os dois idosos da clínica-3.
    Activity(
      id: 'activity-9',
      clinicId: 'clinic-3',
      type: ActivityType.meal,
      title: 'Almoço',
      scheduledTime: _today(12, 0),
      participants: [
        ActivityParticipant(
          residentId: 'resident-5',
          status: ActivityStatus.completed,
          completedAt: _today(12, 10),
          registeredBy: 'Coordenadora Ana Paula',
        ),
        ActivityParticipant(
          residentId: 'resident-6',
          status: ActivityStatus.completed,
          completedAt: _today(12, 15),
          registeredBy: 'Coordenadora Ana Paula',
        ),
      ],
    ),
    Activity(
      id: 'activity-10',
      clinicId: 'clinic-3',
      type: ActivityType.sleep,
      title: 'Soneca da tarde',
      scheduledTime: _today(13, 30),
      participants: [
        ActivityParticipant(
          residentId: 'resident-5',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    Activity(
      id: 'activity-11',
      clinicId: 'clinic-3',
      type: ActivityType.medication,
      title: 'Sinvastatina 20mg',
      scheduledTime: _today(20, 0),
      medicationId: 'medication-4',
      participants: [
        ActivityParticipant(
          residentId: 'resident-6',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    Activity(
      id: 'activity-12',
      clinicId: 'clinic-3',
      type: ActivityType.other,
      title: 'Visita da família',
      scheduledTime: _today(16, 0),
      detail: 'Visita agendada dos filhos no pátio.',
      participants: [
        ActivityParticipant(
          residentId: 'resident-6',
          status: ActivityStatus.pending,
        ),
      ],
    ),
    Activity(
      id: 'activity-15',
      clinicId: 'clinic-3',
      type: ActivityType.physicalActivity,
      title: 'Caminhada no jardim',
      scheduledTime: _tomorrow(9, 30),
      detail: 'Caminhada leve acompanhada pela equipe.',
      participants: [
        ActivityParticipant(
          residentId: 'resident-5',
          status: ActivityStatus.pending,
        ),
        ActivityParticipant(
          residentId: 'resident-6',
          status: ActivityStatus.pending,
        ),
      ],
    ),
  ];

  static final List<HealthRecord> healthRecords = [
    HealthRecord(
      id: 'health-1',
      residentId: 'resident-1',
      type: 'Pressão arterial',
      value: '130/85 mmHg',
      recordedAt: _today(8, 0),
      recordedBy: 'Enfermeira Juliana Martins',
    ),
    HealthRecord(
      id: 'health-2',
      residentId: 'resident-2',
      type: 'Glicose',
      value: '118 mg/dL',
      recordedAt: _today(7, 0),
      recordedBy: 'Enfermeira Juliana Martins',
    ),
    HealthRecord(
      id: 'health-3',
      residentId: 'resident-3',
      type: 'Pressão arterial',
      value: '122/78 mmHg',
      recordedAt: _today(9, 2),
      recordedBy: 'Cuidador Pedro Henrique',
    ),
    HealthRecord(
      id: 'health-4',
      residentId: 'resident-6',
      type: 'Frequência cardíaca',
      value: '76 bpm',
      recordedAt: _today(9, 30),
      recordedBy: 'Coordenadora Ana Paula',
    ),
  ];

  static final List<Medication> medications = [
    Medication(
      id: 'medication-1',
      residentId: 'resident-1',
      name: 'Losartana',
      dosage: '50mg',
      form: MedicationForm.tablet,
      frequency: '1x ao dia, pela manhã',
      startDate: _today(0, 0).subtract(const Duration(days: 60)),
      instructions: 'Tomar com água, em jejum.',
      prescribedBy: 'Dr. Marcos Vinícius (cardiologista)',
    ),
    Medication(
      id: 'medication-2',
      residentId: 'resident-2',
      name: 'Metformina',
      dosage: '850mg',
      form: MedicationForm.tablet,
      frequency: 'A cada 12 horas',
      startDate: _today(0, 0).subtract(const Duration(days: 120)),
      instructions: 'Tomar após as refeições.',
      prescribedBy: 'Dra. Patrícia Souza (endocrinologista)',
    ),
    Medication(
      id: 'medication-3',
      residentId: 'resident-3',
      name: 'Donepezila',
      dosage: '5mg',
      form: MedicationForm.tablet,
      frequency: '1x ao dia, à noite',
      startDate: _today(0, 0).subtract(const Duration(days: 30)),
      instructions: 'Tomar antes de dormir.',
      prescribedBy: 'Dr. Heitor Campos (neurologista)',
    ),
    Medication(
      id: 'medication-4',
      residentId: 'resident-6',
      name: 'Sinvastatina',
      dosage: '20mg',
      form: MedicationForm.tablet,
      frequency: '1x ao dia, à noite',
      startDate: _today(0, 0).subtract(const Duration(days: 90)),
      prescribedBy: 'Dr. Marcos Vinícius (cardiologista)',
    ),
  ];

  static final _now = DateTime.now();

  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'notification-1',
      type: NotificationType.medicationOverdue,
      title: 'Medicação atrasada',
      message:
          'José Carlos Pereira está há 45 minutos sem tomar a Metformina '
          '850mg.',
      createdAt: _now.subtract(const Duration(minutes: 45)),
      audience: ViewerRole.staff,
    ),
    AppNotification(
      id: 'notification-2',
      type: NotificationType.medicationUpcoming,
      title: 'Medicação próxima do horário',
      message: 'Sinvastatina 20mg de Rosa Maria Duarte às 20h.',
      createdAt: _now.subtract(const Duration(minutes: 10)),
      audience: ViewerRole.staff,
    ),
    AppNotification(
      id: 'notification-3',
      type: NotificationType.upcomingEvent,
      title: 'Evento perto de começar',
      message: 'Roda de música começa em 30 minutos, no salão principal.',
      createdAt: _now.subtract(const Duration(minutes: 5)),
    ),
    AppNotification(
      id: 'notification-4',
      type: NotificationType.healthAlert,
      title: 'Alerta de saúde',
      message:
          'Pressão arterial de Maria Aparecida Souza está acima do normal '
          '(130/85 mmHg).',
      createdAt: _now.subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: 'notification-5',
      type: NotificationType.upcomingEvent,
      title: 'Consulta agendada para amanhã',
      message: 'Aferição de pressão de Maria Aparecida e José Carlos às 9h.',
      createdAt: _now.subtract(const Duration(hours: 3)),
      audience: ViewerRole.staff,
      read: true,
    ),
    AppNotification(
      id: 'notification-6',
      type: NotificationType.general,
      title: 'Atividade concluída',
      message:
          'Sebastião Rodrigues concluiu a sessão de fisioterapia de quadril '
          'com sucesso.',
      createdAt: _now.subtract(const Duration(hours: 5)),
      audience: ViewerRole.guardian,
    ),
    AppNotification(
      id: 'notification-7',
      type: NotificationType.general,
      title: 'Novo responsável cadastrado',
      message:
          'Camila Torres foi cadastrada e aguarda vínculo com um idoso da '
          'clínica.',
      createdAt: _now.subtract(const Duration(hours: 8)),
      audience: ViewerRole.staff,
      read: true,
    ),
    AppNotification(
      id: 'notification-8',
      type: NotificationType.general,
      title: 'Obrigado pelo feedback!',
      message: 'Recebemos sua sugestão e nossa equipe já está analisando.',
      createdAt: _now.subtract(const Duration(days: 1)),
      read: true,
    ),
  ];
}
