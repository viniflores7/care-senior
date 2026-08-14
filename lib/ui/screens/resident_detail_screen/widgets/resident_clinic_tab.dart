import 'package:flutter/material.dart';
// TODO(usuário): reativar o mapa real — ver comentário mais abaixo.
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/mock_map_preview/mock_map_preview.dart';

/// Aba "Clínica": dados de contato e localização da clínica onde o idoso
/// está, mais as anotações de saúde gerais.
class ResidentClinicTab extends StatelessWidget {
  const ResidentClinicTab({
    super.key,
    required this.clinic,
    required this.resident,
  });

  final Clinic? clinic;
  final Resident? resident;

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
      ],
    );
  }
}
