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
  final String? err;
  final VoidCallback? onStartSetApiKey;

  const ChatAction({
    super.key,
    required this.chatType,
    required this.onTapSendQuestion,
    required this.onTapSetApiKey, required this.onChangeChatType,
    required this.state,
    this.err,
    this.onStartSetApiKey
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
    final err = widget.err;

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
        if (err != null) Text(err,
          style: TextStyle(color: ColorRes.red, fontSize: DimenRes.size_12),
        ),
        AppChatInput(
          allowSendNewChat:!_isLoading,
          onTapSendQuestion:  widget.onTapSendQuestion,
        ),
        if (err != null) AppButton(
          label: StringRes.changeApiKey,
          onPressed: () => widget.onStartSetApiKey?.call(),
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