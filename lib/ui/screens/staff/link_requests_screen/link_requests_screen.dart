import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/link_requests_screen/link_requests_screen_view_model.dart';
import 'package:care_senior_study/ui/screens/staff/link_requests_screen/widgets/pending_link_request_card.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

class LinkRequestsScreen extends StatefulWidget {
  const LinkRequestsScreen({super.key});

  @override
  State<LinkRequestsScreen> createState() => _LinkRequestsScreenState();
}

class _LinkRequestsScreenState extends State<LinkRequestsScreen> {
  final viewModel = LinkRequestsScreenViewModel();
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
      title: 'Solicitações de vínculo',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!viewModel.hasAnyRequest) {
            return Text(
              'Nenhuma solicitação pendente no momento.',
              style: AppTextStyle.bodyStyle,
            ).center();
          }

          final requests = viewModel.requests;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Buscar por responsável ou idoso',
                controller: _searchController,
                onChanged: viewModel.updateSearch,
              ),
              const SizedBox(height: 16),
              if (requests.isEmpty)
                Text(
                  'Nenhum resultado para sua busca.',
                  style: AppTextStyle.bodyStyle,
                ).padding(top: 24).center()
              else
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: requests.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return FadeSlideIn(
                      child: PendingLinkRequestCard(
                        request: request,
                        onTap: () =>
                            viewModel.navigateToReview(context, request),
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
