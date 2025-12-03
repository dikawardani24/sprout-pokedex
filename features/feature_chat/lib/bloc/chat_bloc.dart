import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:core/usecase/request/ask_ai_req.dart';
import 'package:core/usecase/request/get_detail_req.dart';
import 'package:core/usecase/request/greet_req.dart';
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
  final AiGreetUseCase _aiGreetUseCase;

  ChatBloc(this._getDetailPokeUseCase, this._aiUseCase, this._aiGreetUseCase): super(const ChatState.initial()) {
    on<GetDetailAndGreetingEvent>(
      _getDetailPokemon,
      transformer: restartable(),
    );

    on<AskQuestionEvent>(
      _askQuestion,
      transformer: concurrent()
    );
  }

  void _handleAnswer(ChatMessage? answer, Emitter<ChatState> emit) {
    if (answer == null) {
      emit(ChatState.notAnswered(List.of(_messages)));
      return;
    }
    _messages.add(answer);
    emit(ChatState.gotAnswered(List.of(_messages)));
  }

  Future<void> _askQuestion(AskQuestionEvent event, Emitter<ChatState> emit) async {
    final question = ChatMessage.question(
      text: event.question,
      when: DateTime.now()
    );

    _messages.add(question);
    emit(ChatState.questionAdded(List.of(_messages)));
    final result = await _aiUseCase.execute(AskAiReq(question));
    result.when(
        success: (answer) => _handleAnswer(answer, emit),
        error: (err) => emit(ChatState.errorGetAnswer(getErrorMessage(err), List.of(_messages)))
    );
  }

  Future<void> _getDetailPokemon(GetDetailAndGreetingEvent event, Emitter<ChatState> emit) async {
    final id = event.id;
    emit(ChatState.loadingGetDetailPokemon());
    if (id == null || id <= 0) {
      final result = await _aiGreetUseCase.execute(GreetReq(null));
      result.when(
        success: (data) =>  _handleAnswer(data, emit),
        error: (err) => emit(ChatState.errorGetAnswer(getErrorMessage(err), List.of(_messages)))
      );
      return;
    }

    final result = await _getDetailPokeUseCase.execute(GetDetailReq(id: id));
    result.when(
      success: (data) => emit(ChatState.gotDetailPokemon(data)),
      error: (err) =>emit(ChatState.errorGetDetail(getErrorMessage(err)))
    );
  }
}