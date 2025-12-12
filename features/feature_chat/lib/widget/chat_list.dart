import 'package:core/core.dart';
import 'package:feature_chat/widget/chat_greeting.dart';
import 'package:flutter/material.dart';

import 'chat_widget.dart';

class ChatList extends StatelessWidget{
  final List<ChatMessage> messages;
  final AppPokemonDetail? detail;
  final ScrollController? controller;

  const ChatList({super.key, required this.messages, this.detail, this.controller});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return ChatGreeting(appPokemonDetail: detail);
    }

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (_, index) {
        final message = messages[index];
        return ChatWidget(chatMessage: message);
      },
    );
  }
}