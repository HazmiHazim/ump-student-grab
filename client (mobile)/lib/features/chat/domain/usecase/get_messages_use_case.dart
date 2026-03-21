import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_message.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/repository/chat_repository.dart';

class GetMessagesUseCase implements UseCase<List<ChatMessage>, GetMessagesParams> {
  final ChatRepository _repository;
  GetMessagesUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatMessage>>> call(GetMessagesParams params) =>
      _repository.getMessages(params.chatId, params.participantId);
}

class GetMessagesParams {
  final int chatId;
  final int participantId;
  const GetMessagesParams({required this.chatId, required this.participantId});
}
