import 'package:ump_student_grab_mobile/features/chat/domain/repository/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repository;
  SendMessageUseCase(this._repository);

  void call(SendMessageParams params) => _repository.sendMessage(
        params.chatId,
        params.userId,
        params.senderName,
        params.content,
      );
}

class SendMessageParams {
  final int chatId;
  final int userId;
  final String senderName;
  final String content;

  const SendMessageParams({
    required this.chatId,
    required this.userId,
    required this.senderName,
    required this.content,
  });
}
