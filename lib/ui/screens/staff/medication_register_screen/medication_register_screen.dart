import 'package:flutter/material.dart';
import 'package:care_senior_study/routing/args/medication_register_screen_arguments.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/medication_register_screen/medication_register_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

class MedicationRegisterScreen extends StatefulWidget {
  const MedicationRegisterScreen({super.key, required this.args});

  final MedicationRegisterScreenArguments args;

  @override
  State<MedicationRegisterScreen> createState() =>
      _MedicationRegisterScreenState();
}

class _MedicationRegisterScreenState extends State<MedicationRegisterScreen> {
  late final viewModel = MedicationRegisterScreenViewModel(
    residentId: widget.args.residentId,
  );

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Cadastrar medicamento',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Nome do medicamento',
                  controller: viewModel.nameController,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Dosagem (ex: 50mg)',
                  controller: viewModel.dosageController,
                ),
                const SizedBox(height: 16),
                Text('Via/apresentação', style: AppTextStyle.subtitleStyle),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: MedicationRegisterScreenViewModel.forms.map((form) {
                    final isSelected = viewModel.selectedForm == form;
                    return ChoiceChip(
                      label: Text(form),
                      selected: isSelected,
                      selectedColor: AppColor.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColor.white : AppColor.textDark,
                      ),
                      onSelected: (_) => viewModel.selectForm(form),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Frequência (ex: a cada 8 horas)',
                  controller: viewModel.frequencyController,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Instruções (opcional)',
                  controller: viewModel.instructionsController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Prescrito por (opcional)',
                  controller: viewModel.prescribedByController,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
