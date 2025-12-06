import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:core/usecase/request/save_history_req.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_chat/bloc/chat_event.dart';
import 'package:feature_chat/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatMessage> _messages= [];

  final GetDetailPokeUseCase _getDetailPokeUseCase;
  final AskAiUseCase _aiUseCase;
  final AiSteamAskUseCase _aiSteamAskUseCase;
  final SaveHistoryUseCase _saveHistoryUseCase;
  final GetMessageByHistoryUseCase _getMessageByHistoryUseCase;

  ChatHistory? _chatHistory;
  ChatMessage? _currentAnswer;
  AppPokemonDetail? _appPokemonDetail;

  ChatBloc(this._getDetailPokeUseCase, this._aiUseCase, this._aiSteamAskUseCase, this._saveHistoryUseCase, this._getMessageByHistoryUseCase): super(const ChatState.initial()) {
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

  Future<void> _getDetailPokemon(GetDetailAndGreetingEvent event, Emitter<ChatState> emit) async {
    final id = event.id;
    if (id == null || id <= 0) return;

    emit(ChatState.loadingGetDetailPokemon());
    final result = await _getDetailPokeUseCase.execute(GetDetailReq(id: id));
    result.when(
      success: (data) {
        _appPokemonDetail = data;
        emit(ChatState.gotDetailPokemon(data));
      },
      error: (err) =>emit(ChatState.errorGetDetail(getErrorMessage(err)))
    );
  }

  void _saveChatHistory() {
    if (_messages.isEmpty) return;
    ChatHistory? current = _chatHistory;

    final lastUser = _messages.lastWhere((e) => e.isUser);
    current ??= ChatHistory(
      title: lastUser.text,
      when: lastUser.when
    );

    _saveHistoryUseCase.execute(
      SaveHistoryReq(
        chatHistory: current,
        chatMessages: _messages
      )
    ).then((_) {});
  }

  Future<void> _loadHistoryMessage(LoadHistoryChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatState.loadingMessageByHistory());
    final result = await _getMessageByHistoryUseCase.execute(GetMessageByHistoryReq(event.chatHistory));
    result.when(
      success: (data) {
        _messages.clear();
        _messages.addAll(data);
        _chatHistory = event.chatHistory;
        emit(ChatState.gotMessageByHistory(data));
      },
      error: (err) => emit(ChatState.errGetMessageByHistory(getErrorMessage(err)))
    );
  }
  
  @override
  Future<void> close()  {
    _saveChatHistory();
    return super.close();
  }
}