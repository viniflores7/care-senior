import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/pending_link_request.dart';
import 'package:care_senior_study/ui/widgets/app_avatar/app_avatar.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';

class PendingLinkRequestCard extends StatelessWidget {
  const PendingLinkRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  final PendingLinkRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final residentNames = request.residents
        .map((resident) => resident.name)
        .join(', ');

    return AppCard(
      leading: AppAvatar(
        name: request.guardian.name,
        photoPath: request.guardian.photoPath,
      ),
      title: request.guardian.name,
      subtitle: request.residents.length == 1
          ? 'Idoso: $residentNames'
          : '${request.residents.length} idosos: $residentNames',
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
