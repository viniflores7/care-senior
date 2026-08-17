import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/data/models/outing_request.dart';
import 'package:care_senior_study/data/models/outing_request_status.dart';
import 'package:care_senior_study/data/models/resident.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';
import 'package:care_senior_study/ui/widgets/fade_slide_in/fade_slide_in.dart';

/// Aba "Saídas": pedidos do responsável pra levar o(s) idoso(s) pra fora da
/// clínica (ex.: fim de semana em família), com o status de aprovação da
/// equipe.
class GuardianOutingRequestsTab extends StatelessWidget {
  const GuardianOutingRequestsTab({
    super.key,
    required this.requests,
    required this.residents,
    required this.onNewRequest,
  });

  final List<OutingRequest> requests;
  final List<Resident> residents;
  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    final residentNameById = {for (final r in residents) r.id: r.name};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          label: 'Nova solicitação de saída',
          icon: Icons.add,
          onPressed: onNewRequest,
        ),
        const SizedBox(height: 16),
        if (requests.isEmpty)
          Text(
            'Nenhuma solicitação de saída ainda.',
            style: AppTextStyle.bodyStyle,
          ).padding(top: 24).center()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final request = requests[index];
              return FadeSlideIn(
                child: _OutingRequestCard(
                  request: request,
                  residentName: residentNameById[request.residentId] ?? '',
                ),
              );
            },
          ).expanded(),
      ],
    );
  }
}

class _OutingRequestCard extends StatelessWidget {
  const _OutingRequestCard({required this.request, required this.residentName});

  final OutingRequest request;
  final String residentName;

  static final _dateTimeFormat = DateFormat('dd/MM HH:mm');

  Color get _statusColor => switch (request.status) {
    OutingRequestStatus.approved => AppColor.success,
    OutingRequestStatus.rejected => AppColor.danger,
    _ => AppColor.warning,
  };

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: residentName,
      subtitle:
          '${_dateTimeFormat.format(request.departureAt)} → '
          '${_dateTimeFormat.format(request.returnAt)}',
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _statusColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          request.status,
          style: AppTextStyle.captionStyle.copyWith(
            color: _statusColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: (request.notes != null || request.rejectionReason != null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (request.notes != null)
                  Text(request.notes!, style: AppTextStyle.captionStyle)
                      .padding(top: 8),
                if (request.rejectionReason != null)
                  Text(
                    'Motivo da recusa: ${request.rejectionReason}',
                    style: AppTextStyle.captionStyle.copyWith(
                      color: AppColor.danger,
                    ),
                  ).padding(top: 8),
              ],
            )
          : null,
    );
  }
}
