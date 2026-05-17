import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';

class CustomChatList extends StatelessWidget {
  final String recipientName;
  final String lastMessage;

  const CustomChatList({
    super.key,
    required this.recipientName,
    required this.lastMessage
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppColor.primary,
        child: Text("A", style: TextStyle(color: Colors.white)),
      ),
      title: Text(recipientName),
      subtitle: Text(lastMessage),
    );
  }
}
