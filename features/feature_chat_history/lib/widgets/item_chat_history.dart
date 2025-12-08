import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

typedef OnSelectHistory = Function(ChatHistory);
typedef OnDeleteAction = Function();

class ItemChatHistory extends StatelessWidget{
  final ChatHistory chatHistory;
  final OnSelectHistory? onSelectHistory;
  final OnDeleteAction? onDeleteAction;

  const ItemChatHistory({
    super.key,
    required this.chatHistory,
    this.onSelectHistory,
    this.onDeleteAction
  });

  Widget _buildContent() => Column(
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
  );

  @override
  Widget build(BuildContext context) => AppCard(
    color: ColorRes.grey.withAlpha(90),
    onTap: () => onSelectHistory?.call(chatHistory),
    child: Padding(
      padding: EdgeInsetsGeometry.all(DimenRes.size_16),
      child: Row(
        children: [
          Expanded(child: _buildContent()),
          AppIconButton(
            icon: IconRes.iconDelete,
            iconColor: ColorRes.red.withAlpha(95),
            backgroundColor: ColorRes.transparent,
            onTap: onDeleteAction,
          )
        ],
      ),
    ),
  );

}