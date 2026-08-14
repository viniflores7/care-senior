import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';

/// Sobre o app — conteúdo estático e ilustrativo (versão fixa, texto de
/// termos/privacidade é só um placeholder de estudo, não texto jurídico real).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _version = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Sobre o app',
      body: ListView(
        children: [
          Text('Care Senior', style: AppTextStyle.titleStyle),
          const SizedBox(height: 4),
          Text('Versão $_version', style: AppTextStyle.captionStyle),
          const SizedBox(height: 16),
          Text(
            'O Care Senior conecta famílias e clínicas para acompanhar, no '
            'dia a dia, a agenda, a saúde e o bem-estar de idosos '
            'institucionalizados.',
            style: AppTextStyle.bodyStyle,
          ),
          const SizedBox(height: 24),
          Text(
            'Termos de uso e privacidade',
            style: AppTextStyle.subtitleStyle,
          ),
          const SizedBox(height: 8),
          Text(
            'Este é um projeto de estudo — o texto abaixo é apenas '
            'ilustrativo e não constitui um termo de uso real. Os dados '
            'exibidos no app são fictícios e usados só para fins de '
            'demonstração.',
            style: AppTextStyle.bodyStyle.copyWith(color: AppColor.textDark),
          ),
        ],
      ),
    );
  }
}
