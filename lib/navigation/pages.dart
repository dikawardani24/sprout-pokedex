import 'package:feature_chat/chat_history_page.dart';
import 'package:feature_chat/chat_page.dart';
import 'package:feature_detail/detail_page.dart';
import 'package:feature_home/home_page.dart';
import 'package:flutter/material.dart';

class Pages {
  static Widget homePage({
    OnStartDetail? onStartDetail,
    OnStartChat? onStartChat
  }) => HomePage(
    onStartDetail: onStartDetail,
    onStartChat: onStartChat,
  );

  static Widget detailPage(int id) => DetailPage(id: id);

  static Widget chatPage({int? id, OnStartChatHistory? onStartChatHistory}) => ChatPage(
    pokemonId: id,
    onStartChatHistory: onStartChatHistory,
  );

  static Widget chatHistoryPage() => const ChatHistoryPage();
}