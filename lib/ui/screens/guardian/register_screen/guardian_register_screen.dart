import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/guardian/register_screen/guardian_register_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';
import 'package:care_senior_study/ui/widgets/medication_draft_list/medication_draft_list.dart';
import 'package:care_senior_study/ui/widgets/photo_capture_field/photo_capture_field.dart';

class GuardianRegisterScreen extends StatefulWidget {
  const GuardianRegisterScreen({super.key});

  @override
  State<GuardianRegisterScreen> createState() => _GuardianRegisterScreenState();
}

class _GuardianRegisterScreenState extends State<GuardianRegisterScreen> {
  final viewModel = GuardianRegisterScreenViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Criar conta de responsável',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StepIndicator(step: viewModel.step),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: AppMotion.medium,
                  child: viewModel.step == 0
                      ? _GuardianInfoStep(
                          key: const ValueKey('guardian-step'),
                          viewModel: viewModel,
                        )
                      : _ResidentInfoStep(
                          key: const ValueKey('resident-step'),
                          viewModel: viewModel,
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

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          step == 0 ? 'Passo 1 de 2 · Seus dados' : 'Passo 2 de 2 · Seu idoso',
          style: AppTextStyle.captionStyle,
        ).expanded(),
        const SizedBox(width: 12),
        for (var i = 0; i < 2; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          AnimatedContainer(
            duration: AppMotion.medium,
            curve: AppMotion.curve,
            width: 28,
            height: 6,
            decoration: BoxDecoration(
              color: i <= step ? AppColor.primary : AppColor.greyMedium,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ],
    );
  }
}

class _GuardianInfoStep extends StatelessWidget {
  const _GuardianInfoStep({super.key, required this.viewModel});

  final GuardianRegisterScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Quem é você?', style: AppTextStyle.titleStyle),
          const SizedBox(height: 8),
          Text(
            'Essas informações identificam sua conta como responsável.',
            style: AppTextStyle.bodyStyle,
          ),
          const SizedBox(height: 20),
          PhotoCaptureField(
            photoPath: viewModel.guardianPhotoPath,
            onPhotoChanged: viewModel.setGuardianPhoto,
            label: 'Foto de perfil (opcional)',
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Nome completo',
            controller: viewModel.guardianNameController,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'E-mail',
            controller: viewModel.guardianEmailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'CPF',
            controller: viewModel.guardianCpfController,
            keyboardType: TextInputType.number,
            inputFormatters: [viewModel.guardianCpfMaskFormatter],
          ),
          const SizedBox(height: 8),
          Text(
            'Ambiente de testes: o acesso usa sempre a senha 123456.',
            style: AppTextStyle.captionStyle,
          ),
          if (viewModel.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage!,
              style: const TextStyle(color: AppColor.danger),
            ),
          ],
          const SizedBox(height: 24),
          AppButton(label: 'Continuar', onPressed: viewModel.goToResidentStep),
        ],
      ),
    );
  }
}

class _ResidentInfoStep extends StatelessWidget {
  const _ResidentInfoStep({super.key, required this.viewModel});

  final GuardianRegisterScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Agora, o seu idoso', style: AppTextStyle.titleStyle),
          const SizedBox(height: 8),
          Text(
            'Quanto mais completo, mais fácil fica para a clínica assumir '
            'o cuidado assim que vocês fecharem.',
            style: AppTextStyle.bodyStyle,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              spacing: 12,
              children: [
                const Icon(Icons.info_outline, color: AppColor.primaryDark),
                Text(
                  'Este cadastro ainda não vincula seu idoso a uma clínica. '
                  'Depois de concluir, use "Buscar clínicas" para entrar em '
                  'contato — a equipe da clínica escolhida faz o vínculo '
                  'usando os dados que você preencher aqui.',
                  style: AppTextStyle.captionStyle,
                ).expanded(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PhotoCaptureField(
            photoPath: viewModel.residentPhotoPath,
            onPhotoChanged: viewModel.setResidentPhoto,
            label: 'Foto do idoso (opcional)',
          ),
          const SizedBox(height: 20),
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
            label: 'Notas de saúde (opcional)',
            controller: viewModel.healthNotesController,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text('Humor (opcional)', style: AppTextStyle.subtitleStyle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: GuardianRegisterScreenViewModel.moods.map((mood) {
              final isSelected = viewModel.selectedMood == mood;
              return ChoiceChip(
                label: Text(mood),
                selected: isSelected,
                selectedColor: AppColor.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColor.white : AppColor.textDark,
                ),
                onSelected: (_) => viewModel.selectMood(mood),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Peculiaridades (opcional)',
            controller: viewModel.peculiaritiesController,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Contato de emergência (opcional)',
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
          const SizedBox(height: 24),
          Text('Medicamentos (opcional)', style: AppTextStyle.subtitleStyle),
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
          Row(
            spacing: 12,
            children: [
              AppButton(
                label: 'Voltar',
                type: ButtonType.secondary,
                onPressed: viewModel.goBackToGuardianStep,
              ).expanded(),
              AppButton(
                label: 'Concluir cadastro',
                isLoading: viewModel.isSaving,
                onPressed: () => viewModel.submit(context),
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }
}
