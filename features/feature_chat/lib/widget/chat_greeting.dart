import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ChatGreeting extends StatelessWidget{
  final AppPokemonDetail? appPokemonDetail;

  const ChatGreeting({super.key, this.appPokemonDetail});

  @override
  Widget build(BuildContext context) {
    final detail = appPokemonDetail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: DimenRes.size_16,
      children: [
        if (detail != null) AppNetworkImage(
          imageUrl: detail.imageUrl,
          imageSize: DimenRes.size_100,
          imageErrSize: DimenRes.size_100,
        ),
        if (detail != null) Text(StringRes.greetChatWithTopic(detail.name), textAlign: TextAlign.center),
        if (detail == null) Text(StringRes.greetChat, textAlign: TextAlign.center)
      ],
    );
  }

}