import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_history_state.freezed.dart';

@freezed
abstract class ChatHistoryState with _$ChatHistoryState {
  const factory ChatHistoryState.initial() = _Initial;
  const factory ChatHistoryState.loading() = _Loading;
  const factory ChatHistoryState.loadingMore(List<ChatHistory> histories) = _LoadingMore;
  const factory ChatHistoryState.loaded(List<ChatHistory> histories, bool hasReachedMax) = _Loaded;
  const factory ChatHistoryState.error(String message) = _Error;
  const factory ChatHistoryState.loadMoreError(List<ChatHistory> histories, String message) = _LoadMoreError;
}

extension ChatHistoryStateExt on ChatHistoryState {
  bool get isLoading => this is _Loading;
  bool get isLoadMore => this is _LoadingMore;
}
