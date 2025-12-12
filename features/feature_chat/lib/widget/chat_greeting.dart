import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ChatGreeting extends StatelessWidget{
  final AppPokemonDetail? appPokemonDetail;

  const ChatGreeting({super.key, this.appPokemonDetail});

  Widget _buildGreetWithTopic(AppPokemonDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: DimenRes.size_16,
      children: [
        AppNetworkImage(
          imageUrl: detail.imageUrl,
          imageSize: DimenRes.size_100,
          imageErrSize: DimenRes.size_100,
        ),
        Text(StringRes.greetChatWithTopic(detail.name), textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = appPokemonDetail;

    if (detail != null) {
      return _buildGreetWithTopic(detail);
    }
    return Text(StringRes.greetChat, textAlign: TextAlign.center);
  }

}