import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/login_screen/staff_login_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/app_text_field_password/app_text_field_password.dart';
import 'package:care_senior_study/ui/widgets/auth_background/auth_background.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final viewModel = StaffLoginScreenViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Entrar como equipe da clínica',
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
                      'Registre as atividades e dados de saúde dos idosos da sua clínica.',
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
