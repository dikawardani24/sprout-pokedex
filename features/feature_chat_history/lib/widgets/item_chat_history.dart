import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ItemChatHistory extends StatelessWidget{
  final ChatHistory chatHistory;

  const ItemChatHistory({super.key, required this.chatHistory});

  @override
  Widget build(BuildContext context) => AppCard(
    color: ColorRes.grey.withAlpha(90),
    child: Padding(
      padding: EdgeInsetsGeometry.all(DimenRes.size_16),
      child: Column(
        spacing: DimenRes.size_8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(chatHistory.title.firstLetterUpperCase,
            maxLines: 1,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: DimenRes.size_16
            ),
          ),
          Text(chatHistory.when.format(),
            style: TextStyle(
              fontSize: DimenRes.size_10,
              fontStyle: FontStyle.italic
            ),
          )
        ],
      ),
    ),
  );

}