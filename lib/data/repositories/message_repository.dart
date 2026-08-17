import 'package:care_senior_study/data/mock/mock_data.dart';
import 'package:care_senior_study/data/models/message.dart';

abstract class MessageRepository {
  Future<List<Message>> getMessagesByResidentId(String residentId);

  Future<Message> sendMessage({
    required String residentId,
    required String senderRole,
    required String senderName,
    required String text,
  });
}

class MockMessageRepository implements MessageRepository {
  static const _latency = Duration(milliseconds: 300);

  final List<Message> _messages = List.of(MockData.messages);

  @override
  Future<List<Message>> getMessagesByResidentId(String residentId) async {
    await Future.delayed(_latency);
    final messages = _messages
        .where((message) => message.residentId == residentId)
        .toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return messages;
  }

  @override
  Future<Message> sendMessage({
    required String residentId,
    required String senderRole,
    required String senderName,
    required String text,
  }) async {
    await Future.delayed(_latency);
    final message = Message(
      id: 'message-${_messages.length + 1}-${DateTime.now().microsecondsSinceEpoch}',
      residentId: residentId,
      senderRole: senderRole,
      senderName: senderName,
      text: text,
      sentAt: DateTime.now(),
    );
    _messages.add(message);
    return message;
  }
}
