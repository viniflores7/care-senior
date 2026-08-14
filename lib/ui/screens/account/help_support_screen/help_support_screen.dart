import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';

/// Suporte — texto curto + contato via WhatsApp, mesmo padrão de contato já
/// usado para falar com uma clínica.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _supportWhatsapp = '5561999999999';

  Future<void> _contactSupport() async {
    final message = Uri.encodeComponent(
      'Olá! Preciso de ajuda com o app Care Senior.',
    );
    final uri = Uri.parse('https://wa.me/$_supportWhatsapp?text=$message');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Ajuda / Suporte',
      body: ListView(
        children: [
          Text('Precisa de ajuda?', style: AppTextStyle.titleStyle),
          const SizedBox(height: 8),
          Text(
            'Fale com a nossa equipe de suporte pelo WhatsApp — respondemos '
            'em horário comercial.',
            style: AppTextStyle.bodyStyle,
          ),
          const SizedBox(height: 24),
          AppButton(label: 'Falar no WhatsApp', onPressed: _contactSupport),
        ],
      ),
    );
  }
}
