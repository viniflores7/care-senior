import 'package:get_it/get_it.dart';
import 'package:care_senior_study/data/models/message.dart';
import 'package:care_senior_study/data/repositories/message_repository.dart';

class MessageService {
  final _messageRepository = GetIt.I<MessageRepository>();

  Future<List<Message>> getMessagesByResidentId(String residentId) {
    return _messageRepository.getMessagesByResidentId(residentId);
  }

  Future<Message> sendMessage({
    required String residentId,
    required String senderRole,
    required String senderName,
    required String text,
  }) {
    return _messageRepository.sendMessage(
      residentId: residentId,
      senderRole: senderRole,
      senderName: senderName,
      text: text,
    );
  }
}
