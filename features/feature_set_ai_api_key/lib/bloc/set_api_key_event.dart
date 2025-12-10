import 'package:equatable/equatable.dart';

abstract class SetApiKeyEvent extends Equatable{}

class SaveApiKeyEvent extends SetApiKeyEvent {
  final String apiKey;

  SaveApiKeyEvent(this.apiKey);

  @override
  List<Object?> get props => [apiKey];
}
