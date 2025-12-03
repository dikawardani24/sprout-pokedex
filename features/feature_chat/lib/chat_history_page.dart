import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ChatHistoryPage extends StatelessWidget {

  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton.noBackground(
          icon: IconRes.iconNavBack,
          iconColor: context.iconThemColor,
          onTap: context.goBack,
        ),
        title: Text(StringRes.pokeChat,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}