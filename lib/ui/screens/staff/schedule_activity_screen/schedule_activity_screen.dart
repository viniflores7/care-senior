import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/activity_type.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/routing/args/schedule_activity_screen_arguments.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/schedule_activity_screen/schedule_activity_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/activity_category_icon/activity_category_icon.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_search_field/app_search_field.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';
import 'package:care_senior_study/ui/widgets/photo_capture_field/photo_capture_field.dart';

class ScheduleActivityScreen extends StatefulWidget {
  const ScheduleActivityScreen({super.key, required this.args});

  final ScheduleActivityScreenArguments args;

  @override
  State<ScheduleActivityScreen> createState() => _ScheduleActivityScreenState();
}

class _ScheduleActivityScreenState extends State<ScheduleActivityScreen> {
  late final viewModel = ScheduleActivityScreenViewModel(
    clinicId: widget.args.clinicId,
    preselectedResidentIds: widget.args.preselectedResidentIds,
  );
  final _residentSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.loadResidents();
  }

  @override
  void dispose() {
    _residentSearchController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: viewModel.selectedTime,
    );
    if (time != null) {
      viewModel.selectTime(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Agendar atividade',
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
                      Text('Categoria', style: AppTextStyle.subtitleStyle),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ActivityType.all
                            .map(
                              (type) => _CategoryChip(
                                type: type,
                                isSelected: viewModel.selectedType == type,
                                onTap: () => viewModel.selectType(type),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        label: 'Título',
                        controller: viewModel.titleController,
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: viewModel.selectedTime.format(context),
                        type: ButtonType.outlined,
                        icon: Icons.schedule_outlined,
                        onPressed: () => _pickTime(context),
                      ),
                      if (viewModel.needsDetail) ...[
                        const SizedBox(height: 16),
                        AppTextField(
                          label: viewModel.detailLabel,
                          controller: viewModel.detailController,
                        ),
                      ],
                      if (viewModel.needsPhoto) ...[
                        const SizedBox(height: 16),
                        PhotoCaptureField(
                          photoPath: viewModel.photoPath,
                          onPhotoChanged: viewModel.setPhoto,
                          label: 'Foto do medicamento (opcional)',
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        'Idosos participantes',
                        style: AppTextStyle.subtitleStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selecione quem vai participar dessa atividade.',
                        style: AppTextStyle.captionStyle,
                      ),
                      const SizedBox(height: 12),
                      AppSearchField(
                        controller: _residentSearchController,
                        hint: 'Buscar idoso',
                        onChanged: viewModel.updateResidentSearch,
                      ),
                      if (viewModel.clinicResidents.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: viewModel.allResidentsSelected,
                          onChanged: (_) => viewModel.toggleSelectAllResidents(),
                          title: Text(
                            'Selecionar todos',
                            style: AppTextStyle.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],
                      if (viewModel.filteredResidents.isEmpty)
                        Text(
                          'Nenhum idoso encontrado.',
                          style: AppTextStyle.bodyStyle,
                        ).padding(vertical: 8)
                      else
                        ...viewModel.filteredResidents.map(
                          (resident) => FadeSlideIn(
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: viewModel.selectedResidentIds.contains(
                                resident.id,
                              ),
                              onChanged: (_) =>
                                  viewModel.toggleResident(resident.id),
                              title: Text(resident.name),
                              subtitle: Text('Quarto ${resident.roomNumber}'),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColor.white : AppColor.primaryDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.curve,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : AppColor.primarySoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            ActivityCategoryIcon(type: type, color: color, size: 20),
            Text(
              type,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
