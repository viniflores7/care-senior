import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/role_selection_screen/role_selection_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/auth_background/auth_background.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final viewModel = RoleSelectionScreenViewModel();

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      showAppBar: false,
      body: AuthBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/logo.svg', height: 72),
              const SizedBox(height: 24),
              Text(
                'Como você quer acompanhar o cuidado?',
                style: AppTextStyle.bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Sou responsável/familiar',
                onPressed: () => viewModel.navigateToGuardianLogin(context),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Sou da equipe da clínica',
                type: ButtonType.secondary,
                onPressed: () => viewModel.navigateToStaffLogin(context),
              ),
              const SizedBox(height: 24),
              FadeSlideIn(
                child: TextButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.appIntroScreen),
                  icon: const Icon(
                    Icons.auto_awesome_outlined,
                    size: 18,
                    color: AppColor.primaryDark,
                  ),
                  label: const Text('Não conhece o Care Senior? Clique aqui!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
