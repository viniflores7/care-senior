import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';
import 'package:care_senior_study/ui/widgets/mock_map_preview/mock_map_preview.dart';

/// Aba "Clínica": lista de idosos (entrada pro perfil completo de cada um)
/// e as filas de solicitações administrativas primeiro — é o que a equipe
/// mais usa no dia a dia — com os dados de contato/localização da clínica
/// no final, já que mudam raramente.
class ClinicInfoTab extends StatelessWidget {
  const ClinicInfoTab({
    super.key,
    required this.clinic,
    required this.residents,
    required this.onViewResident,
    required this.onAddGuardian,
    required this.canManageRequests,
    required this.pendingLinkRequestsCount,
    required this.onViewLinkRequests,
    required this.pendingOutingRequestsCount,
    required this.onViewOutingRequests,
  });

  final Clinic? clinic;
  final List<Resident> residents;
  final void Function(String residentId) onViewResident;
  final VoidCallback onAddGuardian;

  /// Só coordenadoras/enfermeiras veem as filas administrativas — ver
  /// `StaffRole.canManageRequests`.
  final bool canManageRequests;

  /// Responsáveis autocadastrados que já contataram esta clínica e aguardam
  /// a equipe preencher `clinicId`/quarto do idoso — ver
  /// `LinkRequestsScreen`.
  final int pendingLinkRequestsCount;
  final VoidCallback onViewLinkRequests;

  /// Pedidos de saída de idosos da clínica aguardando aprovação — ver
  /// `OutingRequestsScreen`.
  final int pendingOutingRequestsCount;
  final VoidCallback onViewOutingRequests;

  @override
  Widget build(BuildContext context) {
    final clinic = this.clinic;
    if (clinic == null) {
      return Text(
        'Informações da clínica indisponíveis.',
        style: AppTextStyle.bodyStyle,
      ).center();
    }

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        Text('Idosos da clínica', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 12),
        if (residents.isEmpty)
          Text(
            'Nenhum idoso vinculado ainda.',
            style: AppTextStyle.bodyStyle,
          ).padding(bottom: 12)
        else
          for (final resident in residents)
            FadeSlideIn(
              child: AppCard(
                leading: AppAvatar(
                  name: resident.name,
                  photoPath: resident.photoPath,
                ),
                title: resident.name,
                subtitle:
                    'Quarto ${resident.roomNumber} · ${resident.age} anos',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => onViewResident(resident.id),
              ).padding(bottom: 12),
            ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Adicionar responsável',
          type: ButtonType.outlined,
          icon: Icons.person_add_outlined,
          onPressed: onAddGuardian,
        ),
        if (canManageRequests) ...[
          const SizedBox(height: 12),
          AppButton(
            label: pendingLinkRequestsCount > 0
                ? 'Solicitações de vínculo ($pendingLinkRequestsCount)'
                : 'Solicitações de vínculo',
            type: ButtonType.outlined,
            icon: Icons.mark_email_unread_outlined,
            onPressed: onViewLinkRequests,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: pendingOutingRequestsCount > 0
                ? 'Solicitações de saída ($pendingOutingRequestsCount)'
                : 'Solicitações de saída',
            type: ButtonType.outlined,
            icon: Icons.directions_walk_outlined,
            onPressed: onViewOutingRequests,
          ),
        ],
        const SizedBox(height: 32),
        const Divider(color: AppColor.greyMedium),
        const SizedBox(height: 24),
        Text(clinic.name, style: AppTextStyle.titleStyle),
        const SizedBox(height: 8),
        Text(clinic.address, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 4),
        Text(clinic.phone, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 4),
        Text(clinic.operatingHours, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 16),
        MockMapPreview(address: clinic.address),
        const SizedBox(height: 24),
        Text('Atividades oferecidas', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: clinic.activities
              .map((activity) => Chip(label: Text(activity)))
              .toList(),
        ),
        const SizedBox(height: 24),
        Text('Responsável', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 8),
        Text(clinic.responsiblePeople, style: AppTextStyle.bodyStyle),
      ],
    );
  }
}
