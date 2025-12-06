import 'package:feature_chat/chat_page.dart';
import 'package:feature_chat_history/feature_chat_history.dart';
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

  static Widget detailPage({
    required int id,
    OnStartChatWithDetail? onStartChatWithDetail
  }) => DetailPage(
    id: id,
    onStartChatWithDetail: onStartChatWithDetail,
  );

  static Widget chatPage({int? id, OnStartChatHistory? onStartChatHistory}) => ChatPage(
    pokemonId: id,
    onStartChatHistory: onStartChatHistory,
  );

  static Widget chatHistoryPage() => const ChatHistoryPage();
}