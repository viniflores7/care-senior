import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/medication_draft.dart';
import 'package:care_senior_study/data/models/medication_form.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

/// Folha para adicionar um medicamento ainda durante o cadastro do idoso
/// (responsável ou equipe) — o idoso ainda não existe, então o resultado é
/// só um [MedicationDraft] em memória, persistido junto no final do
/// cadastro.
class MedicationDraftSheet extends StatefulWidget {
  const MedicationDraftSheet({super.key});

  @override
  State<MedicationDraftSheet> createState() => _MedicationDraftSheetState();
}

class _MedicationDraftSheetState extends State<MedicationDraftSheet> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _prescribedByController = TextEditingController();
  String _selectedForm = MedicationForm.all.first;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _instructionsController.dispose();
    _prescribedByController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_nameController.text.trim().isEmpty ||
        _dosageController.text.trim().isEmpty ||
        _frequencyController.text.trim().isEmpty) {
      return;
    }

    Navigator.of(context).pop(
      MedicationDraft(
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        form: _selectedForm,
        frequency: _frequencyController.text.trim(),
        instructions: _instructionsController.text.trim().isEmpty
            ? null
            : _instructionsController.text.trim(),
        prescribedBy: _prescribedByController.text.trim().isEmpty
            ? null
            : _prescribedByController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Adicionar medicamento', style: AppTextStyle.subtitleStyle),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Nome do medicamento',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Dosagem (ex: 50mg)',
                controller: _dosageController,
              ),
              const SizedBox(height: 16),
              Text('Via/apresentação', style: AppTextStyle.subtitleStyle),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MedicationForm.all.map((form) {
                  final isSelected = _selectedForm == form;
                  return ChoiceChip(
                    label: Text(form),
                    selected: isSelected,
                    selectedColor: AppColor.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColor.white : AppColor.textDark,
                    ),
                    onSelected: (_) => setState(() => _selectedForm = form),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Frequência (ex: a cada 8 horas)',
                controller: _frequencyController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Instruções (opcional)',
                controller: _instructionsController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Prescrito por (opcional)',
                controller: _prescribedByController,
              ),
              const SizedBox(height: 20),
              AppButton(label: 'Adicionar', onPressed: _confirm),
            ],
          ),
        ),
      ),
    );
  }
}
