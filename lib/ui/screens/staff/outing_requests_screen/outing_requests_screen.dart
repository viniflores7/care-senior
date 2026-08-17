import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/outing_requests_screen/outing_requests_screen_view_model.dart';
import 'package:care_senior_study/ui/screens/staff/outing_requests_screen/widgets/outing_request_review_card.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

class OutingRequestsScreen extends StatefulWidget {
  const OutingRequestsScreen({super.key});

  @override
  State<OutingRequestsScreen> createState() => _OutingRequestsScreenState();
}

class _OutingRequestsScreenState extends State<OutingRequestsScreen> {
  final viewModel = OutingRequestsScreenViewModel();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Solicitações de saída',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!viewModel.hasAnyRequest) {
            return Text(
              'Nenhuma solicitação de saída pendente no momento.',
              style: AppTextStyle.bodyStyle,
            ).center();
          }

          final items = viewModel.items;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Buscar por idoso ou responsável',
                controller: _searchController,
                onChanged: viewModel.updateSearch,
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                Text(
                  'Nenhum resultado para sua busca.',
                  style: AppTextStyle.bodyStyle,
                ).padding(top: 24).center()
              else
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return FadeSlideIn(
                      child: OutingRequestReviewCard(
                        item: item,
                        onApprove: () => viewModel.approve(item.request),
                        onReject: () =>
                            viewModel.reject(context, item.request),
                      ),
                    );
                  },
                ).expanded(),
            ],
          );
        },
      ),
    );
  }
}
