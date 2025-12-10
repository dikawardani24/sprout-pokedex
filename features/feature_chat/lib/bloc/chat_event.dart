import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {}

class InitChatEvent extends ChatEvent {
  final int? id;
  final DateTime dateTime;

  InitChatEvent(this.id, this.dateTime);

  @override
  List<Object?> get props => [id, dateTime];
}

class AskQuestionEvent extends ChatEvent {
  final String question;
  final bool isStream;

  AskQuestionEvent(this.question, {this.isStream = false});

  @override
  List<Object?> get props => [question];

}

class LoadHistoryChatEvent extends ChatEvent {
  final ChatHistory chatHistory;

  LoadHistoryChatEvent(this.chatHistory);

  @override
  List<Object?> get props => [chatHistory];
}

class SaveChatEvent extends ChatEvent {
  final DateTime reqWhen;

  SaveChatEvent(this.reqWhen);

  @override
  List<Object?> get props => [reqWhen];
}
