import 'package:flutter/material.dart';
// TODO(usuário): reativar o mapa real — ver comentário mais abaixo.
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/guardian.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/mock_map_preview/mock_map_preview.dart';

/// Aba "Clínica": dados de contato e localização da clínica onde o idoso
/// está, anotações de saúde gerais e — só pra equipe — os responsáveis
/// cadastrados e as ações de vínculo (adicionar responsável, desvincular).
class ResidentClinicTab extends StatelessWidget {
  const ResidentClinicTab({
    super.key,
    required this.clinic,
    required this.resident,
    required this.guardians,
    required this.isStaff,
    required this.onAddGuardian,
    required this.canManageLink,
    required this.onUnlinkResident,
  });

  final Clinic? clinic;
  final Resident? resident;
  final List<Guardian> guardians;
  final bool isStaff;
  final VoidCallback onAddGuardian;

  /// Só coordenadoras/enfermeiras desvinculam o idoso da clínica — ver
  /// `StaffRole.canManageRequests`.
  final bool canManageLink;
  final VoidCallback onUnlinkResident;

  Future<void> _confirmUnlink(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Desvincular idoso'),
        content: Text(
          'Tem certeza que deseja desvincular ${resident?.name ?? 'o idoso'} '
          'desta clínica? O idoso volta ao estado "sem clínica" e some da '
          'lista de idosos da clínica.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Desvincular',
              style: TextStyle(color: AppColor.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) onUnlinkResident();
  }

  @override
  Widget build(BuildContext context) {
    final clinic = this.clinic;
    final resident = this.resident;
    if (clinic == null || resident == null) {
      return Text(
        'Informações da clínica indisponíveis.',
        style: AppTextStyle.bodyStyle,
      ).center();
    }

    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        Text(clinic.name, style: AppTextStyle.titleStyle),
        const SizedBox(height: 8),
        Text(clinic.address, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 4),
        Text(clinic.phone, style: AppTextStyle.bodyStyle),
        const SizedBox(height: 16),
        // Mapa real comentado por enquanto — trocar por este bloco quando a
        // API key do Google Maps estiver configurada: Android:
        // android/app/src/main/AndroidManifest.xml (meta-data
        // com.google.android.geo.API_KEY); iOS: ios/Runner/AppDelegate.swift
        // (GMSServices.provideAPIKey); Web: web/index.html (script do Google
        // Maps com a chave).
        //
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(20),
        //   child: SizedBox(
        //     height: 180,
        //     child: GoogleMap(
        //       initialCameraPosition: CameraPosition(
        //         target: LatLng(clinic.latitude, clinic.longitude),
        //         zoom: 15,
        //       ),
        //       markers: {
        //         Marker(
        //           markerId: MarkerId(clinic.id),
        //           position: LatLng(clinic.latitude, clinic.longitude),
        //         ),
        //       },
        //       zoomControlsEnabled: false,
        //       liteModeEnabled: true,
        //     ),
        //   ),
        // ),
        MockMapPreview(address: clinic.address),
        const SizedBox(height: 24),
        Text('Anotações de saúde', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 8),
        Text(
          resident.healthNotes,
          style: AppTextStyle.bodyStyle.copyWith(color: AppColor.primaryDark),
        ),
        if (resident.emergencyContactName != null ||
            resident.emergencyContactPhone != null) ...[
          const SizedBox(height: 24),
          Text('Contato de emergência', style: AppTextStyle.subtitleStyle),
          const SizedBox(height: 8),
          Text(
            [
              resident.emergencyContactName,
              resident.emergencyContactPhone,
            ].whereType<String>().join(' · '),
            style: AppTextStyle.bodyStyle,
          ),
        ],
        const SizedBox(height: 24),
        Text('Responsáveis', style: AppTextStyle.subtitleStyle),
        const SizedBox(height: 8),
        if (guardians.isEmpty)
          Text(
            'Nenhum responsável cadastrado.',
            style: AppTextStyle.bodyStyle,
          )
        else
          for (final guardian in guardians)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                spacing: 12,
                children: [
                  AppAvatar(
                    name: guardian.name,
                    photoPath: guardian.photoPath,
                    radius: 18,
                  ),
                  Text(guardian.name, style: AppTextStyle.bodyStyle),
                ],
              ),
            ),
        if (isStaff) ...[
          const SizedBox(height: 8),
          AppButton(
            label: 'Adicionar responsável',
            type: ButtonType.outlined,
            icon: Icons.person_add_outlined,
            onPressed: onAddGuardian,
          ),
        ],
        if (canManageLink) ...[
          const SizedBox(height: 32),
          const Divider(color: AppColor.greyMedium),
          const SizedBox(height: 16),
          AppButton(
            label: 'Desvincular idoso da clínica',
            type: ButtonType.outlined,
            icon: Icons.link_off,
            onPressed: () => _confirmUnlink(context),
          ),
        ],
      ],
    );
  }
}
