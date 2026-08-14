import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/account/feedback_screen/feedback_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_star_rating/app_star_rating.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

/// RF-009 — envio de feedback pelos usuários (colaborador ou responsável).
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final viewModel = FeedbackScreenViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Enviar feedback',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return ListView(
            children: [
              Text(
                'Sua opinião ajuda a melhorar o Care Senior.',
                style: AppTextStyle.bodyStyle,
              ),
              const SizedBox(height: 24),
              Text(
                'Como você avalia o app?',
                style: AppTextStyle.subtitleStyle,
              ),
              const SizedBox(height: 12),
              AppStarRating(
                value: viewModel.rating,
                onChanged: viewModel.setRating,
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Sugestões, elogios ou problemas',
                controller: viewModel.messageController,
                maxLines: 5,
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
                label: 'Enviar',
                isLoading: viewModel.isSaving,
                onPressed: () => viewModel.submit(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
