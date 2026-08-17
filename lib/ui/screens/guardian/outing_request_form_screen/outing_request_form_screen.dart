import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/routing/args/outing_request_form_screen_arguments.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/guardian/outing_request_form_screen/outing_request_form_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

class OutingRequestFormScreen extends StatefulWidget {
  const OutingRequestFormScreen({super.key, required this.args});

  final OutingRequestFormScreenArguments args;

  @override
  State<OutingRequestFormScreen> createState() =>
      _OutingRequestFormScreenState();
}

class _OutingRequestFormScreenState extends State<OutingRequestFormScreen> {
  late final viewModel = OutingRequestFormScreenViewModel(
    widget.args.residents,
  );
  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(
    BuildContext context,
    DateTime? initial,
    void Function(DateTime) onPicked,
  ) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: initial != null
          ? TimeOfDay.fromDateTime(initial)
          : TimeOfDay.now(),
    );
    if (time == null) return;

    onPicked(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Nova solicitação de saída',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return ListView(
            children: [
              FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (viewModel.residents.length > 1) ...[
                      Text('Idoso', style: AppTextStyle.subtitleStyle),
                      const SizedBox(height: 12),
                      RadioGroup<String>(
                        groupValue: viewModel.selectedResidentId,
                        onChanged: (value) => viewModel.selectResident(value!),
                        child: Column(
                          children: [
                            for (final resident in viewModel.residents)
                              RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: resident.id,
                                title: Text(resident.name),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text('Período', style: AppTextStyle.subtitleStyle),
                    const SizedBox(height: 12),
                    AppButton(
                      label: viewModel.departureAt != null
                          ? 'Saída: ${_dateTimeFormat.format(viewModel.departureAt!)}'
                          : 'Escolher horário de saída',
                      type: ButtonType.outlined,
                      icon: Icons.logout,
                      onPressed: () => _pickDateTime(
                        context,
                        viewModel.departureAt,
                        viewModel.setDepartureAt,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: viewModel.returnAt != null
                          ? 'Chegada: ${_dateTimeFormat.format(viewModel.returnAt!)}'
                          : 'Escolher horário de chegada',
                      type: ButtonType.outlined,
                      icon: Icons.login,
                      onPressed: () => _pickDateTime(
                        context,
                        viewModel.returnAt,
                        viewModel.setReturnAt,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label:
                          'Informações importantes (destino, medicação a '
                          'levar, contato de emergência...)',
                      controller: viewModel.notesController,
                      maxLines: 4,
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
                      label: 'Enviar solicitação',
                      isLoading: viewModel.isSaving,
                      onPressed: () => viewModel.submit(context),
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
