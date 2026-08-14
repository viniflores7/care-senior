import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';

/// Explicação do app para quem ainda não decidiu se é colaborador ou
/// responsável — aberta a partir da tela de seleção de papel, antes do
/// login.
class AppIntroScreen extends StatelessWidget {
  const AppIntroScreen({super.key});

  static const _staffFeatures = [
    _Feature(
      icon: Icons.event_note_outlined,
      title: 'Agenda da clínica',
      description:
          'Veja e registre as atividades de todos os idosos, iniciando e '
          'concluindo em poucos toques — mesmo em grupo.',
    ),
    _Feature(
      icon: Icons.medication_outlined,
      title: 'Medicamentos estruturados',
      description:
          'Dosagem, via, frequência e instruções sempre à mão — separados '
          'da agenda do dia a dia.',
    ),
    _Feature(
      icon: Icons.monitor_heart_outlined,
      title: 'Saúde em dia',
      description:
          'Registre sinais vitais e acompanhe o histórico de cada idoso da '
          'clínica.',
    ),
    _Feature(
      icon: Icons.star_border_outlined,
      title: 'Feedback pra família',
      description:
          'Uma nota e um comentário a cada atividade concluída, visíveis '
          'ao responsável.',
    ),
  ];

  static const _guardianFeatures = [
    _Feature(
      icon: Icons.badge_outlined,
      title: 'Cadastre-se antes de escolher',
      description:
          'Registre seus dados e os do seu idoso — saúde, humor, '
          'peculiaridades e até medicamentos — antes mesmo de contatar '
          'uma clínica.',
    ),
    _Feature(
      icon: Icons.apartment_outlined,
      title: 'Busque clínicas parceiras',
      description:
          'Encontre clínicas e fale direto no WhatsApp. Quando fechar, a '
          'equipe já recebe seu cadastro pronto.',
    ),
    _Feature(
      icon: Icons.visibility_outlined,
      title: 'Acompanhe de perto',
      description:
          'Agenda, saúde e feedback da equipe sobre cada atividade do seu '
          'idoso, tudo num só lugar.',
    ),
    _Feature(
      icon: Icons.notifications_outlined,
      title: 'Nunca perca um alerta',
      description: 'Notificações de medicação, eventos e novidades da clínica.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Como funciona o Care Senior',
      body: ListView(
        children: [
          _StaggeredReveal(
            delay: Duration.zero,
            child: Text(
              'Um só app para cuidar junto — clínica e família na mesma '
              'página, cada um com sua visão.',
              style: AppTextStyle.bodyStyle,
            ),
          ),
          const SizedBox(height: 28),
          _StaggeredReveal(
            delay: const Duration(milliseconds: 60),
            child: _RoleSection(
              icon: Icons.medical_services_outlined,
              label: 'Para a equipe da clínica',
              features: _staffFeatures,
              startDelayMs: 120,
            ),
          ),
          const SizedBox(height: 28),
          _StaggeredReveal(
            delay: const Duration(milliseconds: 120),
            child: _RoleSection(
              icon: Icons.family_restroom_outlined,
              label: 'Para o responsável',
              features: _guardianFeatures,
              startDelayMs: 380,
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Entendi, continuar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _RoleSection extends StatelessWidget {
  const _RoleSection({
    required this.icon,
    required this.label,
    required this.features,
    required this.startDelayMs,
  });

  final IconData icon;
  final String label;
  final List<_Feature> features;
  final int startDelayMs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColor.primarySoft,
              child: Icon(icon, color: AppColor.primaryDark, size: 20),
            ),
            Text(label, style: AppTextStyle.titleStyle),
          ],
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < features.length; i++)
          _StaggeredReveal(
            delay: Duration(milliseconds: startDelayMs + i * 70),
            child: _FeatureRow(feature: features[i]),
          ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Icon(feature.icon, color: AppColor.primary, size: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.title, style: AppTextStyle.subtitleStyle),
                const SizedBox(height: 2),
                Text(feature.description, style: AppTextStyle.captionStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

/// Revela o filho com um pequeno atraso — dá o efeito de cascata usado
/// nesta tela para tornar a explicação mais convidativa.
class _StaggeredReveal extends StatefulWidget {
  const _StaggeredReveal({required this.delay, required this.child});

  final Duration delay;
  final Widget child;

  @override
  State<_StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<_StaggeredReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: AppMotion.medium,
      curve: AppMotion.curve,
      offset: _visible ? Offset.zero : const Offset(0, 0.12),
      child: AnimatedOpacity(
        duration: AppMotion.medium,
        curve: AppMotion.curve,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
