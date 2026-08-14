import 'package:flutter/material.dart';
import 'package:care_senior_study/data/models/app_notification.dart';
import 'package:care_senior_study/data/models/notification_type.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/screens/notifications/notifications_screen_view_model.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';
import 'package:care_senior_study/ui/widgets/app_card/app_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final viewModel = NotificationsScreenViewModel();

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
    return AppBasePage(
      title: 'Notificações',
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.notifications.isEmpty) {
            return Center(
              child: Text(
                'Você não tem notificações no momento.',
                style: AppTextStyle.bodyStyle,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            itemCount: viewModel.notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = viewModel.notifications[index];
              return _NotificationCard(
                notification: notification,
                onTap: () => viewModel.markAsRead(notification),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  static const _iconByType = {
    NotificationType.medicationOverdue: Icons.medication_outlined,
    NotificationType.medicationUpcoming: Icons.schedule_outlined,
    NotificationType.upcomingEvent: Icons.event_note_outlined,
    NotificationType.healthAlert: Icons.monitor_heart_outlined,
    NotificationType.general: Icons.info_outline,
  };

  static const _colorByType = {
    NotificationType.medicationOverdue: AppColor.danger,
    NotificationType.medicationUpcoming: AppColor.warning,
    NotificationType.upcomingEvent: AppColor.primary,
    NotificationType.healthAlert: AppColor.danger,
    NotificationType.general: AppColor.success,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colorByType[notification.type]!;

    return AppCard(
      title: notification.title,
      subtitle: notification.message,
      onTap: onTap,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(_iconByType[notification.type], color: color, size: 20),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _relativeTime(notification.createdAt),
            style: AppTextStyle.captionStyle,
          ),
          if (!notification.read) ...[
            const SizedBox(height: 6),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _relativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) return 'agora';
    if (difference.inMinutes < 60) return 'há ${difference.inMinutes} min';
    if (difference.inHours < 24) return 'há ${difference.inHours} h';
    return 'há ${difference.inDays} dias';
  }
}
