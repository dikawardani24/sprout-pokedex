import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

typedef OnTapSendQuestion = void Function(String question);

class AppChatInput extends StatefulWidget {
  final OnTapSendQuestion? onTapSendQuestion;

  const AppChatInput({super.key, this.onTapSendQuestion});

  @override
  State<AppChatInput> createState() => _AppChatInputState();
}

class _AppChatInputState extends State<AppChatInput> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendQuestion() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    widget.onTapSendQuestion?.call(q);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 150),
      child: AppInputField(
        controller: _controller,
        scrollController: _scrollController,  // ONLY here ✔
        textInputType: TextInputType.multiline,
        minLine: 1,
        maxLine: null,
        onChanged: (_) {
          Future.delayed(Duration.zero, () {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
            }
          });
        },
        suffixIcon: AppIconButton.noBackground(
          icon: IconRes.iconSendMessage,
          iconColor: context.iconThemColor,
          onTap: _sendQuestion,
        ),
      ),
    );
  }
}

