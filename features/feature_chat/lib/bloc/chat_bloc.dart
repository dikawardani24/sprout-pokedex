import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../useCase/ask_question_event_use_case.dart';
import '../useCase/get_detail_event_use_case.dart';
import '../useCase/load_history_event_use_case.dart';
import '../useCase/save_history_even_use_case.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatMessage> _messages= [];

  final GetDetailEventUseCase _getDetailPokeUseCase;
  final AskQuestionEventUseCase _askQuestionEventUseCase;
  final SaveHistoryEvenUseCase _saveHistoryUseCase;
  final LoadHistoryEventUseCase _getMessageByHistoryUseCase;

  ChatHistory? _chatHistory;
  ChatMessage? _currentAnswer;
  AppPokemonDetail? _appPokemonDetail;

  ChatBloc(this._getDetailPokeUseCase, this._saveHistoryUseCase, this._getMessageByHistoryUseCase, this._askQuestionEventUseCase): super(const ChatState.initial()) {
    on<GetDetailAndGreetingEvent>(
      _getDetailPokemon,
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

  Future<void> _getDetailPokemon(GetDetailAndGreetingEvent event, Emitter<ChatState> emit) async =>
    await _getDetailPokeUseCase.execute(
      event,
      onLoading: () => emit(ChatState.loadingGetDetailPokemon()),
      onError: (err) => emit(ChatState.errorGetDetail(err)),
      onSuccess: (data, s) {
        _appPokemonDetail = data;
        emit(ChatState.gotDetailPokemon(data, s));
      },
    );

  Future<void> _saveChatEvent(SaveChatEvent event, Emitter<ChatState> emit) async =>
    await _saveHistoryUseCase.execute(
        messages: _messages,
        current: _chatHistory,
        onLoading: () => emit(ChatState.loadingSaveHistory(List.of(_messages))),
        onSuccess: () => emit(ChatState.historySaved(event.reqWhen))
    );

  Future<void> _loadHistoryMessage(LoadHistoryChatEvent event, Emitter<ChatState> emit) async =>
    await _getMessageByHistoryUseCase.execute(
      history: event.chatHistory,
      onLoading: () =>  emit(ChatState.loadingMessageByHistory()),
      onError: (err) => emit(ChatState.errGetMessageByHistory(err)),
      onSuccess: (data) {
        _messages.clear();
        _messages.addAll(data);
        _chatHistory = event.chatHistory;
        emit(ChatState.gotMessageByHistory(data));
      }
    );

  @override
  Future<void> close()  {
    _saveHistoryUseCase.execute(messages: _messages, current: _chatHistory);
    return super.close();
  }
}