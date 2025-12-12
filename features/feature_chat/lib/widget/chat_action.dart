import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import 'app_chat_input.dart';

enum ChatType {
  stream, synchronous;
}

enum ChatActionState {
  loading,
  idle
}

typedef OnChangeChatType = Function(ChatType);

class ChatAction extends StatefulWidget {
  final ChatType chatType;
  final ChatActionState state;
  final OnTapSendQuestion onTapSendQuestion;
  final VoidCallback onTapSetApiKey;
  final OnChangeChatType onChangeChatType;

  const ChatAction({
    super.key,
    required this.chatType,
    required this.onTapSendQuestion,
    required this.onTapSetApiKey, required this.onChangeChatType,
    required this.state
  });

  @override
  State<ChatAction> createState() => _ChatActionState();
}

class _ChatActionState extends State<ChatAction> {
  bool _isStream = false;

  void _toggleStreamAnswer() {
    setState(() {
      _isStream = !_isStream;
    });
    final type = _isStream ? ChatType.stream : ChatType.synchronous;
    widget.onChangeChatType.call(type);
  }

  bool get _isLoading => widget.state == ChatActionState.loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: DimenRes.size_10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: DimenRes.size_10,
          children: [
            if (_isLoading) Expanded(
              flex: 1,
              child: AppChatBubble(
                dotColor: ColorRes.red,
                dotSize: DimenRes.size_16,
              ),
            ),
            Checkbox(value: _isStream, onChanged: (_) => _toggleStreamAnswer()),
            Text(StringRes.realTime)
          ],
        ),
        AppChatInput(
          allowSendNewChat:!_isLoading,
          onTapSendQuestion:  widget.onTapSendQuestion,
        )
      ],
    );
  }

  @override
  void initState() {
    _isStream = widget.chatType == ChatType.stream;
    super.initState();
  }
}