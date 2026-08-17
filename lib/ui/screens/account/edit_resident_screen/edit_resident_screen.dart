import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/routing/args/edit_resident_screen_arguments.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/account/edit_resident_screen/edit_resident_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';
import 'package:care_senior_study/ui/widgets/photo_capture_field/photo_capture_field.dart';

class EditResidentScreen extends StatefulWidget {
  const EditResidentScreen({super.key, required this.args});

  final EditResidentScreenArguments args;

  @override
  State<EditResidentScreen> createState() => _EditResidentScreenState();
}

class _EditResidentScreenState extends State<EditResidentScreen> {
  late final viewModel = EditResidentScreenViewModel(
    residentId: widget.args.residentId,
  );

  @override
  void initState() {
    super.initState();
    viewModel.loadData();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Dados do idoso',
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
                        label: 'Foto do idoso (opcional)',
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Nome do idoso',
                        controller: viewModel.nameController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Idade',
                        controller: viewModel.ageController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Notas de saúde',
                        controller: viewModel.healthNotesController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Text('Humor', style: AppTextStyle.subtitleStyle),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: EditResidentScreenViewModel.moods.map((mood) {
                          final isSelected = viewModel.selectedMood == mood;
                          return ChoiceChip(
                            label: Text(mood),
                            selected: isSelected,
                            selectedColor: AppColor.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColor.white
                                  : AppColor.textDark,
                            ),
                            onSelected: (_) => viewModel.selectMood(mood),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Peculiaridades',
                        controller: viewModel.peculiaritiesController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Contato de emergência',
                        style: AppTextStyle.subtitleStyle,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: 'Nome',
                        controller: viewModel.emergencyContactNameController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Telefone',
                        controller: viewModel.emergencyContactPhoneController,
                        keyboardType: TextInputType.phone,
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
                        label: 'Salvar',
                        isLoading: viewModel.isSaving,
                        onPressed: () => viewModel.save(context),
                      ),
                      const SizedBox(height: 32),
                      const Divider(color: AppColor.greyMedium),
                      const SizedBox(height: 16),
                      Text('Medicamentos', style: AppTextStyle.subtitleStyle),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Cadastrar medicamento',
                        type: ButtonType.outlined,
                        icon: Icons.add,
                        onPressed: () =>
                            viewModel.navigateToAddMedication(context),
                      ).padding(bottom: 16),
                      if (viewModel.medications.isEmpty)
                        Text(
                          'Nenhum medicamento cadastrado ainda.',
                          style: AppTextStyle.bodyStyle,
                        )
                      else
                        ...viewModel.medications.map(
                          (medication) => FadeSlideIn(
                            child: AppCard(
                              title:
                                  '${medication.name} · ${medication.dosage}',
                              subtitle:
                                  '${medication.form} · ${medication.frequency}',
                            ).padding(bottom: 12),
                          ),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
