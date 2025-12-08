import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

abstract class AskQuestionEventUseCase {
  Future<void> execute({
    required AskQuestionEvent event,
    required Emitter<ChatState> emit,
    required List<ChatMessage> messages,
    required AppPokemonDetail? appPokemonDetail,
    required ChatMessage? Function() getCurrentAnswer,
    required void Function(ChatMessage?) setCurrentAnswer,
    required void Function(ChatMessage, int) updateMessageAtIndex,
  });
}

@Injectable(as: AskQuestionEventUseCase)
class AskQuestionEventUseCaseImpl implements AskQuestionEventUseCase{
  final AskAiUseCase _aiUseCase;
  final AiSteamAskUseCase _aiSteamAskUseCase;

  AskQuestionEventUseCaseImpl({
    required AskAiUseCase aiUseCase,
    required AiSteamAskUseCase aiSteamAskUseCase,
  })  : _aiUseCase = aiUseCase,
        _aiSteamAskUseCase = aiSteamAskUseCase;

  @override
  Future<void> execute({
    required AskQuestionEvent event,
    required Emitter<ChatState> emit,
    required List<ChatMessage> messages,
    required AppPokemonDetail? appPokemonDetail,
    required ChatMessage? Function() getCurrentAnswer,
    required void Function(ChatMessage?) setCurrentAnswer,
    required void Function(ChatMessage, int) updateMessageAtIndex,
  }) async {
    final question = _addQuestionToMessages(
      question: event.question,
      messages: messages,
      emit: emit,
    );

    final req = AskAiReq(
      question,
      history: List.of(messages),
      topic: appPokemonDetail?.name,
    );

    if (event.isStream) {
      await _executeStreamQuestion(
        req: req,
        emit: emit,
        messages: messages,
        getCurrentAnswer: getCurrentAnswer,
        setCurrentAnswer: setCurrentAnswer,
        updateMessageAtIndex: updateMessageAtIndex,
      );
    } else {
      await _executeWaitQuestion(
        req: req,
        emit: emit,
        messages: messages,
      );
    }
  }

  ChatMessage _addQuestionToMessages({
    required String question,
    required List<ChatMessage> messages,
    required Emitter<ChatState> emit,
  }) {
    final questionMessage = ChatMessage.question(
      text: question,
      when: DateTime.now(),
    );
    messages.add(questionMessage);
    emit(ChatState.questionAdded(List.of(messages)));
    return questionMessage;
  }

  Future<void> _executeStreamQuestion({
    required AskAiReq req,
    required Emitter<ChatState> emit,
    required List<ChatMessage> messages,
    required ChatMessage? Function() getCurrentAnswer,
    required void Function(ChatMessage?) setCurrentAnswer,
    required void Function(ChatMessage, int) updateMessageAtIndex,
  }) async {
    try {
      final stream = await _aiSteamAskUseCase.stream(req);

      await emit.forEach(
        stream,
        onData: (data) {
          if (data == null || data.isEmpty) {
            return ChatState.notAnswered(List.of(messages));
          }

          _handleChunkAnswer(
            data: data,
            messages: messages,
            getCurrentAnswer: getCurrentAnswer,
            setCurrentAnswer: setCurrentAnswer,
            updateMessageAtIndex: updateMessageAtIndex,
          );

          return ChatState.gotAnswered(List.of(messages));
        },
      );

      setCurrentAnswer(null);
      emit(ChatState.answered(messages));
    } on Exception catch (err) {
      emit(ChatState.errorGetAnswer(getErrorMessage(err), messages));
    }
  }

  Future<void> _executeWaitQuestion({
    required AskAiReq req,
    required Emitter<ChatState> emit,
    required List<ChatMessage> messages,
  }) async {
    final result = await _aiUseCase.execute(req);

    result.when(
      success: (data) {
        if (data == null) {
          emit(ChatState.notAnswered(messages));
          return;
        }
        messages.add(data);
        emit(ChatState.answered(messages));
      },
      error: (err) => emit(
        ChatState.errorGetAnswer(getErrorMessage(err), messages),
      ),
    );
  }

  void _handleChunkAnswer({
    required String? data,
    required List<ChatMessage> messages,
    required ChatMessage? Function() getCurrentAnswer,
    required void Function(ChatMessage?) setCurrentAnswer,
    required void Function(ChatMessage, int) updateMessageAtIndex,
  }) {
    ChatMessage? answer = getCurrentAnswer();
    if (answer == null) {
      answer = ChatMessage.answer(
        text: data ?? "",
        when: DateTime.now(),
      );
      messages.add(answer);
    }

    final updatedAnswer = answer.copyWith(
      when: DateTime.now(),
      text: "${answer.text}$data",
    );

    setCurrentAnswer(updatedAnswer);

    final index = messages.indexWhere((e) => e.uuid == (updatedAnswer.uuid));

    if (index != -1) {
      updateMessageAtIndex(updatedAnswer, index);
    }
  }
}