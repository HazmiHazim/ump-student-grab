class ChatRoomArgs {
  final int chatId;
  final int recipientId;
  final String recipientName;

  const ChatRoomArgs({
    required this.chatId,
    required this.recipientId,
    required this.recipientName,
  });
}
