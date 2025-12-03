
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loadingGetDetailPokemon() = _LoadingGetDetailPokemon;
  const factory ChatState.questionAdded(List<ChatMessage> messages) = _QuestionAdded;
  const factory ChatState.gotAnswered(List<ChatMessage> messages) = _GotAnswered;
  const factory ChatState.notAnswered(List<ChatMessage> messages) = _NotAnswered;
  const factory ChatState.gotDetailPokemon(AppPokemonDetail detail) = _GotDetailPokemon;
  const factory ChatState.errorGetDetail(String message) = _ErrorGetDetail;
  const factory ChatState.errorGetAnswer(String message, List<ChatMessage> messages) = _ErrorGetAnswered;
}