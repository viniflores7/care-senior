import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/staff/outing_requests_screen/outing_requests_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_button/app_button.dart';

class OutingRequestReviewCard extends StatelessWidget {
  const OutingRequestReviewCard({
    super.key,
    required this.item,
    required this.onApprove,
    required this.onReject,
  });

  final StaffOutingRequestItem item;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  static final _dateTimeFormat = DateFormat('dd/MM HH:mm');

  @override
  Widget build(BuildContext context) {
    final request = item.request;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.greyMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.resident.name, style: AppTextStyle.subtitleStyle),
          const SizedBox(height: 4),
          Text(
            'Solicitado por ${item.guardian?.name ?? 'responsável'}',
            style: AppTextStyle.captionStyle,
          ),
          const SizedBox(height: 12),
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.logout,
                size: 18,
                color: AppColor.primaryDark,
              ),
              Text(
                _dateTimeFormat.format(request.departureAt),
                style: AppTextStyle.bodyStyle,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            spacing: 8,
            children: [
              const Icon(Icons.login, size: 18, color: AppColor.primaryDark),
              Text(
                _dateTimeFormat.format(request.returnAt),
                style: AppTextStyle.bodyStyle,
              ),
            ],
          ),
          if (request.notes != null) ...[
            const SizedBox(height: 12),
            Text(request.notes!, style: AppTextStyle.captionStyle),
          ],
          const SizedBox(height: 16),
          Row(
            spacing: 12,
            children: [
              AppButton(
                label: 'Recusar',
                type: ButtonType.outlined,
                onPressed: onReject,
              ).expanded(),
              AppButton(label: 'Aprovar', onPressed: onApprove).expanded(),
            ],
          ),
        ],
      ),
    );
  }
}
