
import 'package:core/core.dart';
import 'package:feature_chat/models/chat_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = _Initial;
  const factory ChatState.loadingGetDetailPokemon() = _LoadingGetDetailPokemon;
  const factory ChatState.loadingAskQuestion() = LoadingAskQuestion;
  const factory ChatState.gotAnswered(List<ChatMessage> messages) = _GotAnswered;
  const factory ChatState.gotDetailPokemon(AppPokemonDetail detail) = _GotDetailPokemon;
  const factory ChatState.errorGetDetail(String message) = _ErrorGetDetail;
  const factory ChatState.errorGetAnswer(String message) = _ErrorGetAnswered;
}