import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:core/usecase/request/get_detail_req.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_chat/bloc/chat_event.dart';
import 'package:feature_chat/bloc/chat_state.dart';
import 'package:feature_chat/models/chat_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatMessage> _messages= [];

  final GetDetailPokeUseCase _getDetailPokeUseCase;

  ChatBloc(this._getDetailPokeUseCase): super(const ChatState.initial()) {
    on<GetDetailEvent>(
      _getDetailPokemon,
      transformer: restartable(),
    );

    on<AskQuestionEvent>(
      _askQuestion,
      transformer: concurrent()
    );
  }

  Future<void> _askQuestion(AskQuestionEvent event, Emitter<ChatState> emit) async {
    _messages.add(ChatMessage.question(event.question));
    _messages.add(ChatMessage.answer("THis is dummy answer for \n${event.question}"));
    emit(ChatState.gotAnswered(List.from(_messages)));
  }

  Future<void> _getDetailPokemon(GetDetailEvent event, Emitter<ChatState> emit) async {
    final id = event.id;
    if (id == null || id <= 0) return;

    final result = await _getDetailPokeUseCase.execute(GetDetailReq(id: id));
    result.when(
      success: (data) => emit(ChatState.gotDetailPokemon(data)),
      error: (err) =>emit(ChatState.errorGetDetail(getErrorMessage(err)))
    );
  }
}