import 'package:flutter/material.dart';
import 'package:care_senior_study/routing/args/health_record_register_screen_arguments.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/health_record_register_screen/health_record_register_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

class HealthRecordRegisterScreen extends StatefulWidget {
  const HealthRecordRegisterScreen({super.key, required this.args});

  final HealthRecordRegisterScreenArguments args;

  @override
  State<HealthRecordRegisterScreen> createState() =>
      _HealthRecordRegisterScreenState();
}

class _HealthRecordRegisterScreenState
    extends State<HealthRecordRegisterScreen> {
  late final viewModel = HealthRecordRegisterScreenViewModel(
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
      title: 'Registrar dado de saúde',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Tipo', style: AppTextStyle.subtitleStyle),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: HealthRecordRegisterScreenViewModel.types.map((
                    type,
                  ) {
                    final isSelected = viewModel.selectedType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: AppColor.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColor.white : AppColor.textDark,
                      ),
                      onSelected: (_) => viewModel.selectType(type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Valor (ex: 120/80 mmHg)',
                  controller: viewModel.valueController,
                ),
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
