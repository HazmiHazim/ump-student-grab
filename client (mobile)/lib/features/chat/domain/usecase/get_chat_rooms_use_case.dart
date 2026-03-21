import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_room.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/repository/chat_repository.dart';

class GetChatRoomsUseCase implements UseCase<List<ChatRoom>, NoParams> {
  final ChatRepository _repository;
  GetChatRoomsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatRoom>>> call(NoParams params) =>
      _repository.getChatRooms();
}
