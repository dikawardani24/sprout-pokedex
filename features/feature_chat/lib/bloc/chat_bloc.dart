import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:core/usecase/ai_steam_ask_use_case.dart';
import 'package:core/usecase/request/ask_ai_req.dart';
import 'package:core/usecase/request/get_detail_req.dart';
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
  ChatMessage? _currentAnswer;

  ChatBloc(this._getDetailPokeUseCase, this._aiUseCase, this._aiSteamAskUseCase): super(const ChatState.initial()) {
    on<GetDetailAndGreetingEvent>(
      _getDetailPokemon,
      transformer: restartable(),
    );

    on<AskQuestionEvent>(
      _askQuestion,
      transformer: concurrent()
    );
  }

  ChatMessage _notifyQuestionAdded(String text, Emitter<ChatState> emit) {
    final question = ChatMessage.question(text: text, when: DateTime.now());
    _messages.add(question);
    emit(ChatState.questionAdded(List.of(_messages)));
    return question;
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

  Future<void> _askQuestionStream(String questionText, Emitter<ChatState> emit) async {
    final history = _messages;
    final question = _notifyQuestionAdded(questionText, emit);

    try {
      final stream = await _aiSteamAskUseCase.stream(
        question: question,
        history: history,
      );

      await emit.forEach(stream, onData: (data) {
        _handleChunkAnswer(data);
        return ChatState.gotAnswered(List.of(_messages));
      });

      _currentAnswer = null;
      emit(ChatState.answered(_messages));
    } on Exception catch(err) {
      emit(ChatState.errorGetAnswer(getErrorMessage(err), _messages));
    }
  }

  Future<void> _askQuestionWait(String questionText, Emitter<ChatState> emit) async {
    final history = _messages;
    final question = _notifyQuestionAdded(questionText, emit);

    final result = await _aiUseCase.execute(AskAiReq(question,
      history: history
    ));

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

  Future<void> _askQuestion(AskQuestionEvent event, Emitter<ChatState> emit) async {
    if (event.isStream) {
      await _askQuestionStream(event.question, emit);
      return;
    }
    await _askQuestionWait(event.question, emit);
  }

  Future<void> _getDetailPokemon(GetDetailAndGreetingEvent event, Emitter<ChatState> emit) async {
    final id = event.id;
    if (id == null || id <= 0) return;

    emit(ChatState.loadingGetDetailPokemon());
    final result = await _getDetailPokeUseCase.execute(GetDetailReq(id: id));
    result.when(
      success: (data) => emit(ChatState.gotDetailPokemon(data)),
      error: (err) =>emit(ChatState.errorGetDetail(getErrorMessage(err)))
    );
  }
}