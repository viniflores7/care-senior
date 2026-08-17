import 'package:flutter/material.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/account/widgets/account_menu_item.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';
import 'package:care_senior_study/utils/navigator.dart';

/// Aba "Perfil": identidade de quem está logado (colaborador ou responsável)
/// + acesso às configurações da conta. Substitui o antigo header/menu do
/// `AppTopBar`.
class AccountTab extends StatelessWidget {
  const AccountTab({
    super.key,
    required this.name,
    required this.subtitle,
    required this.photoPath,
    required this.onSecurityTap,
    required this.onLogout,
  });

  final String name;
  final String subtitle;
  final String? photoPath;

  /// Chamado ao tocar em "Segurança" — o dono da tela navega e recarrega os
  /// dados exibidos aqui (nome/foto) quando volta com alterações salvas.
  final VoidCallback onSecurityTap;
  final VoidCallback onLogout;

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sair', style: TextStyle(color: AppColor.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true) onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FadeSlideIn(
          child: Column(
            children: [
              AppAvatar(name: name, photoPath: photoPath, radius: 40),
              const SizedBox(height: 12),
              Text(
                name,
                style: AppTextStyle.titleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyle.captionStyle),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FadeSlideIn(
          child: AccountMenuItem(
            icon: Icons.lock_outline,
            label: 'Segurança',
            onTap: onSecurityTap,
          ),
        ),
        FadeSlideIn(
          child: AccountMenuItem(
            icon: Icons.help_outline,
            label: 'Ajuda / Suporte',
            onTap: () => navigator(context).pushNamed(Routes.helpSupportScreen),
          ),
        ),
        FadeSlideIn(
          child: AccountMenuItem(
            icon: Icons.info_outline,
            label: 'Sobre o app',
            onTap: () => navigator(context).pushNamed(Routes.aboutScreen),
          ),
        ),
        FadeSlideIn(
          child: AccountMenuItem(
            icon: Icons.feedback_outlined,
            label: 'Enviar feedback',
            onTap: () => navigator(context).pushNamed(Routes.feedbackScreen),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: AppColor.greyMedium),
        const SizedBox(height: 16),
        FadeSlideIn(
          child: AccountMenuItem(
            icon: Icons.logout,
            label: 'Sair da conta',
            color: AppColor.danger,
            onTap: () => _confirmLogout(context),
          ),
        ),
      ],
    );
  }
}
