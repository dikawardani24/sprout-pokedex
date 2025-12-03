import 'package:core_ui/core_ui.dart';
import 'package:feature_chat/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatWidget({super.key, required this.chatMessage});

  Color get _colorBox => chatMessage.isUser ? ColorRes.red.withAlpha(20) : ColorRes.white;
  Radius get _borderRadiusLeft => chatMessage.isUser ? const Radius.circular(DimenRes.size_12) : const Radius.circular(0);
  Radius get _borderRadiusRight => chatMessage.isUser ? const Radius.circular(0) : const Radius.circular(DimenRes.size_12);
  Alignment get _alignment => chatMessage.isUser ? Alignment.centerRight : Alignment.centerLeft;

  @override
  Widget build(BuildContext context) {
    bool isUser = chatMessage.isUser;
    final radius = DimenRes.size_16;

    return Align(
      alignment: _alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: DimenRes.size_16),
        padding: const EdgeInsets.symmetric(horizontal: DimenRes.size_16, vertical: DimenRes.size_16),
        decoration: BoxDecoration(
          color: _colorBox,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: _borderRadiusLeft,
            bottomRight: _borderRadiusRight,
          ),
        ),
        child: Text(
          chatMessage.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

}