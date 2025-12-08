import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'chat_history_event.dart';
import 'chat_history_state.dart';

@injectable
class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState>{
  final GetChatHistoriesUseCase _getChatHistoriesUseCase;
  final DeleteHistoryUseCase _deleteHistoryUseCase;

  bool _hasReachedMax = false;
  List<ChatHistory> _histories = [];

  ChatHistoryBloc(this._getChatHistoriesUseCase, this._deleteHistoryUseCase): super(const ChatHistoryState.initial()) {
    on<GetHistoryEvent>(
      _getHistories,
      transformer: throttleDroppable(Duration(milliseconds: 100))
    );

    on<DeleteHistoryEvent>(
      _deleteHistory,
      transformer: droppable()
    );
  }

  void _errGetHistories(Emitter<ChatHistoryState> emit, bool isLoadMore, dynamic err) {
    final errorMessage = getErrorMessage(err);
    if (isLoadMore) {
      emit(ChatHistoryState.loadMoreError(_histories, errorMessage));
    } else {
      emit(ChatHistoryState.error(errorMessage));
    }
  }


  void _emitLoadingGetPoke(Emitter<ChatHistoryState> emit, bool isLoadMore) {
    if (isLoadMore) {
      emit(ChatHistoryState.loadingMore(_histories));
    } else {
      if (state.isLoading) {
        return;
      }
      emit(const ChatHistoryState.loading());
    }
  }

  void _updateHistories(AppPage<ChatHistory> page, bool isLoadMore) {
    _hasReachedMax = page.isReachMaxLimit;

    if (isLoadMore) {
      _histories = List.from(_histories)..addAll(page.data);
    } else {
      _histories = List.from(page.data);
      _hasReachedMax = false;
    }
  }

  Future<void> _loadHistories(
      Emitter<ChatHistoryState> emit,
      bool isLoadMore
      ) async {
    if (isLoadMore && _hasReachedMax) return;
    _emitLoadingGetPoke(emit, isLoadMore);
    final result = await _getChatHistoriesUseCase.execute(GetChatHistoriesReq(offset: _histories.length));
    result.when(
        success: (data) {
          _updateHistories(data, isLoadMore);
          emit(ChatHistoryState.loaded(
            List.unmodifiable(_histories),
            _hasReachedMax,
          ));
        },
        error: (err) => _errGetHistories(emit, isLoadMore, err)
    );
  }


  Future<void> _getHistories(GetHistoryEvent event, Emitter<ChatHistoryState> emit) async {
    if (!event.isLoadMore) {
      _histories.clear();
      _hasReachedMax = false;
    }
    await _loadHistories(emit, event.isLoadMore);
  }

  Future<void> _deleteHistory(DeleteHistoryEvent event, Emitter<ChatHistoryState> emit) async {
    final history = event.chatHistory;
    final result = await _deleteHistoryUseCase.execute(DeleteHistoryReq(history));
    result.when(
      success: (_) {
        final index = _histories.indexOf(history);
        _histories.removeAt(index);
        emit(ChatHistoryState.historyDeleted(List.of(_histories)));
      },
      error: (err) => emit(ChatHistoryState.errDeleteHistory(getErrorMessage(err)))
    );
  }

}