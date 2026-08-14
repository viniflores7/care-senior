import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/data/models/activity_participant.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/routing/args/activity_detail_screen_arguments.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_motion.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/activity_detail_screen/activity_detail_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/activity_progress_summary/activity_progress_summary.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_star_rating/app_star_rating.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';
import 'package:care_senior_study/ui/widgets/status_badge/status_badge.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({super.key, required this.args});

  final ActivityDetailScreenArguments args;

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  late final viewModel = ActivityDetailScreenViewModel(
    activity: widget.args.activity,
    viewerRole: widget.args.viewerRole,
    focusResidentId: widget.args.focusResidentId,
  );

  @override
  void initState() {
    super.initState();
    viewModel.loadResidents();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final activity = viewModel.activity;

        return AppBasePage(
          title: activity.type,
          bottomNavigationBar: viewModel.isSelecting
              ? _SelectionActionBar(
                  selectedCount: viewModel.selectedCount,
                  onSkip: () => viewModel.skipSelected(context),
                  onComplete: () => viewModel.completeSelected(context),
                )
              : null,
          body: AnimatedSwitcher(
            duration: AppMotion.medium,
            child: viewModel.isLoading
                ? const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    key: const ValueKey('content'),
                    children: [
                      Text(activity.title, style: AppTextStyle.titleStyle),
                      const SizedBox(height: 8),
                      Text(
                        'Horário previsto: ${timeFormat.format(activity.scheduledTime)}',
                        style: AppTextStyle.bodyStyle,
                      ),
                      if (activity.detail != null &&
                          activity.detail!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(activity.detail!, style: AppTextStyle.bodyStyle),
                      ],
                      const SizedBox(height: 16),
                      ActivityProgressSummary(
                        label: 'Presença nesta atividade',
                        completed: viewModel.completedCount,
                        total: viewModel.totalCount,
                      ),
                      if (viewModel.canStartAny) ...[
                        const SizedBox(height: 16),
                        AppButton(
                          label: 'Iniciar atividade',
                          type: ButtonType.outlined,
                          icon: Icons.play_arrow,
                          onPressed: viewModel.startAll,
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Participantes',
                            style: AppTextStyle.subtitleStyle,
                          ).expanded(),
                          if (viewModel.isStaff)
                            TextButton(
                              onPressed: viewModel.toggleSelectionMode,
                              child: Text(
                                viewModel.isSelecting
                                    ? 'Cancelar'
                                    : 'Selecionar vários',
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ...viewModel.participants.map(
                        (participant) => FadeSlideIn(
                          child: _ParticipantTile(
                            participant: participant,
                            residentName:
                                viewModel
                                    .residentFor(participant.residentId)
                                    ?.name ??
                                'Idoso não encontrado',
                            timeFormat: timeFormat,
                            isStaffViewer: viewModel.isStaff,
                            isSelecting: viewModel.isSelecting,
                            isSelected: viewModel.isSelected(
                              participant.residentId,
                            ),
                            canRegisterOutcome: viewModel.canRegisterOutcomeFor(
                              participant,
                            ),
                            onToggleSelected: () => viewModel.toggleSelected(
                              participant.residentId,
                            ),
                            onSkip: () => viewModel.skipActivity(
                              context,
                              participant.residentId,
                            ),
                            onComplete: () => viewModel.completeActivity(
                              context,
                              participant.residentId,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _SelectionActionBar extends StatelessWidget {
  const _SelectionActionBar({
    required this.selectedCount,
    required this.onSkip,
    required this.onComplete,
  });

  final int selectedCount;
  final VoidCallback onSkip;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: AppColor.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedCount == 0
                  ? 'Selecione os idosos'
                  : '$selectedCount selecionado(s)',
              style: AppTextStyle.captionStyle,
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 12,
              children: [
                AppButton(
                  label: 'Pular selecionados',
                  type: ButtonType.secondary,
                  onPressed: selectedCount == 0 ? null : onSkip,
                ).expanded(),
                AppButton(
                  label: 'Concluir selecionados',
                  onPressed: selectedCount == 0 ? null : onComplete,
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({
    required this.participant,
    required this.residentName,
    required this.timeFormat,
    required this.isStaffViewer,
    required this.isSelecting,
    required this.isSelected,
    required this.canRegisterOutcome,
    required this.onToggleSelected,
    required this.onSkip,
    required this.onComplete,
  });

  final ActivityParticipant participant;
  final String residentName;
  final DateFormat timeFormat;

  /// Só a equipe vê quem registrou o status — nunca o responsável, para
  /// evitar constranger um colaborador específico.
  final bool isStaffViewer;
  final bool isSelecting;
  final bool isSelected;
  final bool canRegisterOutcome;
  final VoidCallback onToggleSelected;
  final VoidCallback onSkip;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final showCheckbox = isSelecting && canRegisterOutcome;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.greyLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            children: [
              if (showCheckbox)
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onToggleSelected(),
                )
              else
                AppAvatar(name: residentName, radius: 18),
              Text(residentName, style: AppTextStyle.subtitleStyle).expanded(),
              StatusBadge(status: participant.status),
            ],
          ),
          if (participant.completedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Registrado às ${timeFormat.format(participant.completedAt!)}',
              style: AppTextStyle.captionStyle,
            ),
          ],
          if (isStaffViewer && participant.registeredBy != null) ...[
            const SizedBox(height: 4),
            Text(
              'Registrado por: ${participant.registeredBy}',
              style: AppTextStyle.captionStyle,
            ),
          ],
          if (participant.notes != null && participant.notes!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(participant.notes!, style: AppTextStyle.captionStyle),
          ],
          if (participant.rating != null) ...[
            const SizedBox(height: 8),
            AppStarRating(value: participant.rating!, size: 18),
          ],
          if (participant.comment != null &&
              participant.comment!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(participant.comment!, style: AppTextStyle.captionStyle),
          ],
          if (!isSelecting && canRegisterOutcome) ...[
            const SizedBox(height: 12),
            Row(
              spacing: 12,
              children: [
                AppButton(
                  label: 'Pular',
                  type: ButtonType.secondary,
                  onPressed: onSkip,
                ).expanded(),
                AppButton(label: 'Concluir', onPressed: onComplete).expanded(),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
