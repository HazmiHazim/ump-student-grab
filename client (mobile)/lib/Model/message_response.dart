class MessageResponse {
  final int status;
  final String content;
  final String attachment;
  final int userId;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isSuccess;
  final String responseMessage;

  MessageResponse({
    required this.status,
    required this.content,
    required this.attachment,
    required this.userId,
    required this.createdAt,
    required this.modifiedAt,
    required this.isSuccess,
    required this.responseMessage,
  });

  // Factory constructor to create from JSON
  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
        status: json["status"],
        content: json["content"],
        attachment: json["attachment"],
        userId: json["userId"],
        createdAt: json["createdAt"],
        modifiedAt: json["modifiedAt"],
        isSuccess: json["success"],
        responseMessage: json["responseMessage"]
    );
  }

}