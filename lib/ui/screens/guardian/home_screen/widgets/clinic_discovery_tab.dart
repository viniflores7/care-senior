import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/clinic.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

/// Aba "Buscar clínicas": só mostra clínicas que o responsável ainda não
/// contatou. As já contatadas ficam numa seção separada, aguardando a
/// clínica confirmar o vínculo — assim ele não perde de vista quem já
/// procurou.
class ClinicDiscoveryTab extends StatelessWidget {
  const ClinicDiscoveryTab({
    super.key,
    required this.clinics,
    required this.contactedClinics,
    required this.onContact,
  });

  final List<Clinic> clinics;
  final List<Clinic> contactedClinics;
  final void Function(Clinic clinic) onContact;

  @override
  Widget build(BuildContext context) {
    if (clinics.isEmpty && contactedClinics.isEmpty) {
      return Text(
        'Nenhuma clínica disponível no momento.',
        style: AppTextStyle.bodyStyle,
      ).center();
    }

    return ListView(
      children: [
        if (clinics.isEmpty)
          Text(
            'Você já contatou todas as clínicas disponíveis no momento.',
            style: AppTextStyle.bodyStyle,
          ).padding(bottom: 16)
        else
          for (final clinic in clinics)
            FadeSlideIn(
              child: _ClinicDiscoveryCard(
                clinic: clinic,
                onContact: () => onContact(clinic),
              ).padding(bottom: 16),
            ),
        if (contactedClinics.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Aguardando confirmação (${contactedClinics.length})',
            style: AppTextStyle.subtitleStyle,
          ),
          const SizedBox(height: 4),
          Text(
            'Você já entrou em contato — assim que a clínica confirmar, '
            'o vínculo aparece aqui automaticamente.',
            style: AppTextStyle.captionStyle,
          ),
          const SizedBox(height: 12),
          for (final clinic in contactedClinics)
            FadeSlideIn(
              child: _ContactedClinicRow(clinic: clinic).padding(bottom: 8),
            ),
        ],
      ],
    );
  }
}

class _ContactedClinicRow extends StatelessWidget {
  const _ContactedClinicRow({required this.clinic});

  final Clinic clinic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.greyLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        spacing: 12,
        children: [
          const Icon(Icons.schedule_outlined, color: AppColor.primaryDark),
          Text(clinic.name, style: AppTextStyle.bodyStyle).expanded(),
        ],
      ),
    );
  }
}

class _ClinicDiscoveryCard extends StatelessWidget {
  const _ClinicDiscoveryCard({required this.clinic, required this.onContact});

  final Clinic clinic;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.greyMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO(usuário): trocar por uma imagem real da clínica (clinic.photoPath)
          // quando tiver as fotos — hoje mostramos só um ícone de prédio como placeholder.
          Row(
            spacing: 12,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColor.primarySoft,
                child: Icon(
                  Icons.apartment_outlined,
                  color: AppColor.primaryDark,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(clinic.name, style: AppTextStyle.subtitleStyle),
                  Text(clinic.address, style: AppTextStyle.captionStyle),
                ],
              ).expanded(),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.schedule_outlined, label: clinic.operatingHours),
          const SizedBox(height: 4),
          _InfoRow(
            icon: Icons.checklist_outlined,
            label: clinic.activities.join(' · '),
          ),
          const SizedBox(height: 4),
          _InfoRow(icon: Icons.badge_outlined, label: clinic.responsiblePeople),
          const SizedBox(height: 16),
          AppButton(label: 'Falar no WhatsApp', onPressed: onContact),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Icon(icon, size: 18, color: AppColor.primaryDark),
        Text(label, style: AppTextStyle.bodyStyle).expanded(),
      ],
    );
  }
}
