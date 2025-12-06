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
  final String? topic;
  final bool isStream;

  AskQuestionEvent(this.question, {this.isStream = false, this.topic});

  @override
  List<Object?> get props => [question];

}