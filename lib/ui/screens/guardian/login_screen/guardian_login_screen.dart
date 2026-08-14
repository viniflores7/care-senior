import 'package:flutter/material.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/guardian/login_screen/guardian_login_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/app_text_field_password/app_text_field_password.dart';
import 'package:care_senior_study/ui/widgets/auth_background/auth_background.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

class GuardianLoginScreen extends StatefulWidget {
  const GuardianLoginScreen({super.key});

  @override
  State<GuardianLoginScreen> createState() => _GuardianLoginScreenState();
}

class _GuardianLoginScreenState extends State<GuardianLoginScreen> {
  final viewModel = GuardianLoginScreenViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Entrar como responsável',
      body: AuthBackground(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return SingleChildScrollView(
              child: FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Acompanhe as atividades e a saúde do seu familiar na clínica.',
                      style: AppTextStyle.bodyStyle,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'E-mail',
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextFieldPassword(
                      label: 'Senha',
                      controller: viewModel.passwordController,
                    ),
                    if (viewModel.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: AppColor.danger),
                      ),
                    ],
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Entrar',
                      isLoading: viewModel.isLoading,
                      onPressed: () => viewModel.login(context),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushNamed(Routes.guardianRegisterScreen),
                        child: const Text('Ainda não tem conta? Cadastre-se'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
