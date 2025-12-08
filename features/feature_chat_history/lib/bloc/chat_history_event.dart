import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class ChatHistoryEvent extends Equatable {}

class GetHistoryEvent extends ChatHistoryEvent {
  final bool isLoadMore;

  GetHistoryEvent({required this.isLoadMore});

  @override
  List<Object?> get props => [isLoadMore];

}

class DeleteHistoryEvent extends ChatHistoryEvent {
  final ChatHistory chatHistory;

  DeleteHistoryEvent({required this.chatHistory});

  @override
  List<Object?> get props => [chatHistory];
}