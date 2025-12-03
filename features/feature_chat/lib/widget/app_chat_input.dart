import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

typedef OnTapSendQuestion = void Function(String question);

class AppChatInput extends StatefulWidget {
  final OnTapSendQuestion? onTapSendQuestion;
  final bool allowSendNewChat;

  const AppChatInput({super.key, this.onTapSendQuestion, this.allowSendNewChat = true});

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

  Widget _buildSuffixIcon() {
    if (!widget.allowSendNewChat) {
      return Padding(
        padding: EdgeInsetsGeometry.all(DimenRes.size_10),
        child: Loading(
          size: DimenRes.size_40,
          isCenter: false,
        ),
      );
    }
    return AppIconButton.noBackground(
      icon: IconRes.iconSendMessage,
      iconColor: context.iconThemColor,
      onTap: _sendQuestion,
    );
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
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }
}

