import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {}

class GetDetailEvent extends ChatEvent {
  final int? id;

  GetDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AskQuestionEvent extends ChatEvent {
  final String question;

  AskQuestionEvent(this.question);

  @override
  List<Object?> get props => [question];

}