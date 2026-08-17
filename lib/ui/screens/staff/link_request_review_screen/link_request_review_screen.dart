import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/routing/args/link_request_review_screen_arguments.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/link_request_review_screen/link_request_review_screen_view_model.dart';
import 'package:care_senior_study/ui/screens/staff/link_request_review_screen/widgets/resident_link_review_section.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

class LinkRequestReviewScreen extends StatefulWidget {
  const LinkRequestReviewScreen({super.key, required this.args});

  final LinkRequestReviewScreenArguments args;

  @override
  State<LinkRequestReviewScreen> createState() =>
      _LinkRequestReviewScreenState();
}

class _LinkRequestReviewScreenState extends State<LinkRequestReviewScreen> {
  late final viewModel = LinkRequestReviewScreenViewModel(
    widget.args.request,
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
    final guardian = widget.args.request.guardian;

    return AppBasePage(
      title: 'Revisar solicitação',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Responsável', style: AppTextStyle.subtitleStyle),
                    const SizedBox(height: 12),
                    Row(
                      spacing: 12,
                      children: [
                        AppAvatar(
                          name: guardian.name,
                          photoPath: guardian.photoPath,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guardian.name,
                              style: AppTextStyle.bodyStyle,
                            ),
                            Text(
                              guardian.email,
                              style: AppTextStyle.captionStyle,
                            ),
                            if (guardian.cpf != null)
                              Text(
                                'CPF: ${guardian.cpf}',
                                style: AppTextStyle.captionStyle,
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.args.request.residents.length == 1
                          ? 'Idoso'
                          : 'Idosos',
                      style: AppTextStyle.subtitleStyle,
                    ),
                    const SizedBox(height: 12),
                    for (final resident in widget.args.request.residents)
                      ResidentLinkReviewSection(
                        resident: resident,
                        medications:
                            viewModel.medicationsByResident[resident.id] ??
                            [],
                        roomController: viewModel.roomControllers[
                            resident.id]!,
                      ).padding(bottom: 24),
                    if (viewModel.errorMessage != null) ...[
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: AppColor.danger),
                      ),
                      const SizedBox(height: 16),
                    ],
                    AppButton(
                      label: 'Aceitar vínculo',
                      isLoading: viewModel.isSaving,
                      onPressed: () => viewModel.accept(context),
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
