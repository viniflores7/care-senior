import 'package:flutter/material.dart';
import 'package:care_senior_study/routing/args/edit_resident_screen_arguments.dart';
import 'package:care_senior_study/routing/routes.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/account/account_security_screen/account_security_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/photo_capture_field/photo_capture_field.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final viewModel = AccountSecurityScreenViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadProfile();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Segurança',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return AnimatedSwitcher(
            duration: AppMotion.medium,
            child: viewModel.isLoading
                ? const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    key: const ValueKey('content'),
                    children: [
                      PhotoCaptureField(
                        photoPath: viewModel.photoPath,
                        onPhotoChanged: viewModel.setPhoto,
                        label: 'Foto de perfil',
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        label: 'Nome completo',
                        controller: viewModel.nameController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'CPF',
                        controller: viewModel.cpfController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [viewModel.cpfMaskFormatter],
                      ),
                      if (viewModel.isStaff) ...[
                        const SizedBox(height: 16),
                        _ReadOnlyField(
                          label: 'Instituição',
                          value: viewModel.institutionName ?? '—',
                        ),
                      ],
                      const SizedBox(height: 24),
                      AppButton(
                        label: 'Salvar',
                        isLoading: viewModel.isSaving,
                        onPressed: () => viewModel.save(context),
                      ),
                      if (viewModel.unlinkedResidentId != null) ...[
                        const SizedBox(height: 16),
                        AppButton(
                          label: 'Editar dados do idoso',
                          type: ButtonType.outlined,
                          icon: Icons.badge_outlined,
                          onPressed: () => Navigator.of(context).pushNamed(
                            Routes.editResidentScreen,
                            arguments: EditResidentScreenArguments(
                              residentId: viewModel.unlinkedResidentId!,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.greyLight,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(label, style: AppTextStyle.captionStyle),
          Text(value, style: AppTextStyle.bodyStyle),
        ],
      ),
    );
  }
}
