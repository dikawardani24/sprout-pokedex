import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../useCase/get_detail_event_use_case.dart';
import '../useCase/load_history_event_use_case.dart';
import '../useCase/save_history_even_use_case.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatMessage> _messages= [];

  final GetDetailEventUseCase _getDetailPokeUseCase;
  final AskAiUseCase _aiUseCase;
  final AiSteamAskUseCase _aiSteamAskUseCase;
  final SaveHistoryEvenUseCase _saveHistoryUseCase;
  final LoadHistoryEventUseCase _getMessageByHistoryUseCase;

  ChatHistory? _chatHistory;
  ChatMessage? _currentAnswer;
  AppPokemonDetail? _appPokemonDetail;

  ChatBloc(this._getDetailPokeUseCase, this._saveHistoryUseCase, this._getMessageByHistoryUseCase, this._aiUseCase, this._aiSteamAskUseCase): super(const ChatState.initial()) {
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

  void _handleChunkAnswer(String? data) {
    ChatMessage? answer = _currentAnswer;
    if (answer == null) {
      answer = ChatMessage.answer(text: data ?? "", when: DateTime.now());
      _messages.add(answer);
    }

    _currentAnswer = answer.copyWith(
        when: DateTime.now(),
        text: "${answer.text}$data"
    );

    final index = _messages.indexWhere((e) => e.uuid == (_currentAnswer?.uuid ?? ""));
    _messages[index] = answer;
  }

  Future<void> _askQuestionStream(AskAiReq req, Emitter<ChatState> emit) async {
    try {
      final stream = await _aiSteamAskUseCase.stream(req);

      await emit.forEach(stream, onData: (data) {
        if (data == null || data.isEmpty) return ChatState.notAnswered(List.of(_messages));
        _handleChunkAnswer(data);
        return ChatState.gotAnswered(List.of(_messages));
      });

      _currentAnswer = null;
      emit(ChatState.answered(_messages));
    } on Exception catch(err) {
      emit(ChatState.errorGetAnswer(getErrorMessage(err), _messages));
    }
  }

  Future<void> _askQuestionWait(AskAiReq req, Emitter<ChatState> emit) async {
    final result = await _aiUseCase.execute(req);

    result.when(
        success: (data) {
          if (data == null) {
            emit(ChatState.notAnswered(_messages));
            return;
          }
          _messages.add(data);
          emit(ChatState.answered(_messages));
        },
        error: (err) => emit(ChatState.errorGetAnswer(getErrorMessage(err), _messages))
    );
  }

  ChatMessage _notifyQuestionAdded(String text, Emitter<ChatState> emit) {
    final question = ChatMessage.question(text: text, when: DateTime.now());
    _messages.add(question);
    emit(ChatState.questionAdded(List.of(_messages)));
    return question;
  }

  Future<void> _askQuestion(AskQuestionEvent event, Emitter<ChatState> emit) async {
    final history = _messages;
    final question = _notifyQuestionAdded(event.question, emit);
    final req = AskAiReq(question,
        history: history,
        topic: _appPokemonDetail?.name
    );

    if (event.isStream) {
      await _askQuestionStream(req, emit);
      return;
    }
    await _askQuestionWait(req, emit);
  }

  Future<void> _getDetailPokemon(GetDetailAndGreetingEvent event, Emitter<ChatState> emit) async =>
    await _getDetailPokeUseCase.execute(
      event,
      onLoading: () => emit(ChatState.loadingGetDetailPokemon()),
      onError: (err) => emit(ChatState.errorGetDetail(err)),
      onSuccess: (data) {
        _appPokemonDetail = data;
        emit(ChatState.gotDetailPokemon(data));
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