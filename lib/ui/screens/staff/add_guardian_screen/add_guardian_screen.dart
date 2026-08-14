import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/add_guardian_screen/add_guardian_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';
import 'package:care_senior_study/ui/widgets/medication_draft_list/medication_draft_list.dart';
import 'package:care_senior_study/ui/widgets/photo_capture_field/photo_capture_field.dart';

class AddGuardianScreen extends StatefulWidget {
  const AddGuardianScreen({super.key});

  @override
  State<AddGuardianScreen> createState() => _AddGuardianScreenState();
}

class _AddGuardianScreenState extends State<AddGuardianScreen> {
  final viewModel = AddGuardianScreenViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Adicionar responsável',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return ListView(
            children: [
              FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dados do responsável',
                      style: AppTextStyle.subtitleStyle,
                    ),
                    const SizedBox(height: 16),
                    PhotoCaptureField(
                      photoPath: viewModel.guardianPhotoPath,
                      onPhotoChanged: viewModel.setGuardianPhoto,
                      label: 'Foto do responsável (opcional)',
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Nome do responsável',
                      controller: viewModel.guardianNameController,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'E-mail do responsável',
                      controller: viewModel.guardianEmailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'CPF do responsável',
                      controller: viewModel.guardianCpfController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [viewModel.guardianCpfMaskFormatter],
                    ),
                    const SizedBox(height: 24),
                    Text('Dados do idoso', style: AppTextStyle.subtitleStyle),
                    const SizedBox(height: 16),
                    PhotoCaptureField(
                      photoPath: viewModel.residentPhotoPath,
                      onPhotoChanged: viewModel.setResidentPhoto,
                      label: 'Foto do idoso (opcional)',
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Nome do idoso',
                      controller: viewModel.residentNameController,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Idade',
                      controller: viewModel.residentAgeController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Quarto',
                      controller: viewModel.roomNumberController,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Medicamentos (opcional)',
                      style: AppTextStyle.subtitleStyle,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Adicionar medicamento',
                      type: ButtonType.outlined,
                      icon: Icons.add,
                      onPressed: () => viewModel.addMedicationDraft(context),
                    ).padding(bottom: 12),
                    MedicationDraftList(
                      drafts: viewModel.medicationDrafts,
                      onRemove: viewModel.removeMedicationDraft,
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
                      label: 'Cadastrar e vincular',
                      isLoading: viewModel.isSaving,
                      onPressed: () => viewModel.save(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
