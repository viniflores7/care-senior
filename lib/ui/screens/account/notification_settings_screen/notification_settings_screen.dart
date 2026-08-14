import 'package:flutter/material.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_base_page/app_base_page.dart';

/// Preferências de notificação — só ilustrativo (estado local, sem
/// persistência real, já que não existe backend de notificações no projeto).
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _activityNotifications = true;
  bool _messageNotifications = true;

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      title: 'Notificações',
      body: ListView(
        children: [
          Text(
            'Escolha quais avisos você quer receber.',
            style: AppTextStyle.bodyStyle,
          ),
          const SizedBox(height: 16),
          _NotificationSwitchTile(
            title: 'Atividades',
            subtitle:
                'Avisos sobre atividades pendentes, concluídas ou puladas.',
            value: _activityNotifications,
            onChanged: (value) =>
                setState(() => _activityNotifications = value),
          ),
          const SizedBox(height: 12),
          _NotificationSwitchTile(
            title: 'Mensagens',
            subtitle: 'Avisos de novas mensagens da clínica ou da família.',
            value: _messageNotifications,
            onChanged: (value) => setState(() => _messageNotifications = value),
          ),
        ],
      ),
    );
  }
}

class _NotificationSwitchTile extends StatelessWidget {
  const _NotificationSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.greyMedium),
      ),
      child: Row(
        spacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.subtitleStyle),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyle.captionStyle),
            ],
          ).expanded(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColor.primary,
          ),
        ],
      ),
    );
  }
}
