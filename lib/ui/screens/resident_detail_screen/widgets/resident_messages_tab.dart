import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:care_senior_study/data/models/message.dart';
import 'package:care_senior_study/extensions/widget_modifiers.dart';
import 'package:care_senior_study/style/app_color.dart';
import 'package:care_senior_study/style/app_text_style.dart';
import 'package:care_senior_study/ui/widgets/app_text_field/app_text_field.dart';

/// Aba "Mensagens": recados pontuais entre equipe e responsável sobre este
/// idoso — não é chat em tempo real, só uma lista simples que recarrega ao
/// entrar na tela.
class ResidentMessagesTab extends StatefulWidget {
  const ResidentMessagesTab({
    super.key,
    required this.messages,
    required this.viewerRole,
    required this.onSend,
  });

  final List<Message> messages;
  final String viewerRole;
  final Future<void> Function(String text) onSend;

  @override
  State<ResidentMessagesTab> createState() => _ResidentMessagesTabState();
}

class _ResidentMessagesTabState extends State<ResidentMessagesTab> {
  final _textController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    await widget.onSend(text);
    _textController.clear();
    if (mounted) setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.messages.isEmpty)
          Text(
            'Nenhuma mensagem ainda. Envie um recado abaixo.',
            style: AppTextStyle.bodyStyle,
          ).padding(top: 24).center().expanded()
        else
          ListView.builder(
            reverse: true,
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message =
                  widget.messages[widget.messages.length - 1 - index];
              return _MessageBubble(
                message: message,
                isMine: message.senderRole == widget.viewerRole,
              );
            },
          ).expanded(),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: [
            AppTextField(
              label: 'Mensagem',
              controller: _textController,
              maxLines: 3,
            ).expanded(),
            IconButton.filled(
              onPressed: _isSending ? null : _send,
              style: IconButton.styleFrom(backgroundColor: AppColor.primary),
              icon: const Icon(Icons.send, color: AppColor.white),
            ),
          ],
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine});

  final Message message;
  final bool isMine;

  static final _timeFormat = DateFormat('dd/MM HH:mm');

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMine ? AppColor.primary : AppColor.greyLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMine)
              Text(
                message.senderName,
                style: AppTextStyle.captionStyle.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            Text(
              message.text,
              style: AppTextStyle.bodyStyle.copyWith(
                color: isMine ? AppColor.white : AppColor.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _timeFormat.format(message.sentAt),
              style: AppTextStyle.captionStyle.copyWith(
                color: isMine
                    ? AppColor.white.withValues(alpha: 0.8)
                    : AppColor.textDark.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
