import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      leading: CircleAvatar(child: Text("A")),
      title: Text(recipientName),
      subtitle: Text(lastMessage),
    );
  }
}