import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../useCase/ask_question_event_use_case.dart';
import '../useCase/init_chat_event_use_case.dart';
import '../useCase/load_history_event_use_case.dart';
import '../useCase/save_history_even_use_case.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatMessage> _messages= [];

  final InitChatEventUseCase _initChatEventUseCase;
  final AskQuestionEventUseCase _askQuestionEventUseCase;
  final SaveHistoryEvenUseCase _saveHistoryUseCase;
  final LoadHistoryEventUseCase _getMessageByHistoryUseCase;

  ChatHistory? _chatHistory;
  ChatMessage? _currentAnswer;
  AppPokemonDetail? _appPokemonDetail;

  ChatBloc(this._initChatEventUseCase, this._saveHistoryUseCase, this._getMessageByHistoryUseCase, this._askQuestionEventUseCase): super(const ChatState.initial()) {
    on<InitChatEvent>(
      _initChatEvent,
      transformer: restartable(),
    );

    on<AskQuestionEvent>(
      _askQuestion,
      transformer: concurrent()
    );

    on<LoadHistoryChatEvent>(
      _loadHistoryMessage,
      transformer: throttleDroppable(Duration(milliseconds: 100))
    );

    on<SaveChatEvent>(
      _saveChatEvent
    );
  }

  Future<void> _askQuestion(AskQuestionEvent event, Emitter<ChatState> emit) async =>
    await _askQuestionEventUseCase.execute(
      event: event,
      emit: emit,
      messages: _messages,
      appPokemonDetail: _appPokemonDetail,
      getCurrentAnswer: () => _currentAnswer,
      setCurrentAnswer: (answer) => _currentAnswer = answer,
      updateMessageAtIndex: (answer, index) {
        _messages[index] = answer;
      },
    );

  Future<void> _initChatEvent(InitChatEvent event, Emitter<ChatState> emit) async =>
    await _initChatEventUseCase.execute(
      event,
      onLoading: () => emit(ChatState.loadingGetDetailPokemon()),
      onError: (err) => emit(ChatState.errorGetDetail(err)),
      onSuccess: (data, s) {
        _appPokemonDetail = data;
        emit(ChatState.gotDetailPokemon(data, s));
      },
    );

  Future<void> _saveChatEvent(SaveChatEvent event, Emitter<ChatState> emit) async {
    if (_messages.isEmpty) {
      emit(ChatState.noHistoryToBeSave(event.reqWhen));
      return;
    }
    await _saveHistoryUseCase.execute(
        messages: _messages,
        current: _chatHistory,
        onLoading: () => emit(ChatState.loadingSaveHistory(List.of(_messages))),
        onSuccess: () => emit(ChatState.historySaved(event.reqWhen))
    );
  }

  Future<void> _loadHistoryMessage(LoadHistoryChatEvent event, Emitter<ChatState> emit) async {
    final history = event.chatHistory;
    if (history == null) {
      emit(ChatState.gotMessageByHistory(List.of(_messages)));
      return;
    }
    await _getMessageByHistoryUseCase.execute(
        history: history,
        onLoading: () =>  emit(ChatState.loadingMessageByHistory()),
        onError: (err) => emit(ChatState.errGetMessageByHistory(err)),
        onSuccess: (data) {
          _messages.clear();
          _messages.addAll(data);
          _chatHistory = event.chatHistory;
          emit(ChatState.gotMessageByHistory(List.of(_messages)));
        }
    );
  }

  @override
  Future<void> close()  {
    _saveHistoryUseCase.execute(messages: _messages, current: _chatHistory);
    return super.close();
  }
}