import 'package:equatable/equatable.dart';

abstract class ChatHistoryEvent extends Equatable {}

class GetHistoryEvent extends ChatHistoryEvent {
  final bool isLoadMore;

  GetHistoryEvent({required this.isLoadMore});

  @override
  List<Object?> get props => [isLoadMore];

}