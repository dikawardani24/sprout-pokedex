import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {}

class GetDetailAndGreetingEvent extends ChatEvent {
  final int? id;

  GetDetailAndGreetingEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AskQuestionEvent extends ChatEvent {
  final String question;

  AskQuestionEvent(this.question);

  @override
  List<Object?> get props => [question];

}