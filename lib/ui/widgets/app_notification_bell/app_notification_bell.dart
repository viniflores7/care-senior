import 'package:flutter/material.dart';
import 'package:care_senior_study/style/app_color.dart';

/// Ícone de sino com um indicador de não lidas, usado no header das telas
/// principais (colaborador e responsável).
class AppNotificationBell extends StatelessWidget {
  const AppNotificationBell({
    super.key,
    required this.hasUnread,
    required this.onTap,
  });

  final bool hasUnread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_outlined),
          if (hasUnread)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColor.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.primaryDark, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
