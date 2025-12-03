import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_chat/bloc/chat_bloc.dart';
import 'package:feature_chat/bloc/chat_event.dart';
import 'package:feature_chat/bloc/chat_state.dart';
import 'package:feature_chat/widget/app_chat_input.dart';
import 'package:feature_chat/widget/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

typedef OnStartChatHistory = void Function(BuildContext context);

class ChatPage extends StatefulWidget {
  final int? pokemonId;
  final OnStartChatHistory? onStartChatHistory;

  const ChatPage({
    super.key,
    this.pokemonId,
    this.onStartChatHistory
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  void _askQuestion(BuildContext context, String question) {
    context.read<ChatBloc>().add(AskQuestionEvent(question));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    leading: AppIconButton.noBackground(
      icon: IconRes.iconNavBack,
      iconColor: context.iconThemColor,
      onTap: context.goBack,
    ),
    title: Text(StringRes.pokeChat,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
    actions: [
      AppIconButton.noBackground(
        icon: IconRes.iconHistory,
        iconColor: context.iconThemColor,
        onTap: () => widget.onStartChatHistory?.call(context),
      )
    ],
  );

  Widget _buildContent(BuildContext context, {
    List<ChatMessage> list = const [],
    bool isLoadingAnswer = false,
    String? err
  }) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            ImageRes.pokeBall,
            color: ColorRes.grey.withAlpha(80),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (_, index) => ChatWidget(chatMessage: list[index]),
              ),
            ),
            if (isLoadingAnswer) AppChatBubble(
              dotColor: ColorRes.red,
              dotSize: DimenRes.size_16,
            ),
            if (err != null) Text(err,
              style: TextStyle(color: ColorRes.red, fontSize: DimenRes.size_12),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppChatInput(
                allowSendNewChat: !isLoadingAnswer,
                onTapSendQuestion: (q) => _askQuestion(context, q),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocProvider<ChatBloc>(
        create: (_) =>
        GetIt.I.get<ChatBloc>()..add(GetDetailAndGreetingEvent(widget.pokemonId)),
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            state.maybeWhen(
              gotAnswered: (_) => _scrollToBottom(),
              questionAdded: (_) => _scrollToBottom(),
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              gotAnswered: (messages) => _buildContent(context, list: messages),
              questionAdded: (messages) => _buildContent(context, list: messages, isLoadingAnswer: true),
              errorGetAnswer: (err, messages) => _buildContent(context, list: messages, err: StringErrRes.errGetAnswerAi),
              notAnswered: (messages) => _buildContent(context, list: messages, err: StringErrRes.errGetAnswerAi),
              loadingGetDetailPokemon: () => _buildContent(context, isLoadingAnswer: true),
              orElse: () => _buildContent(context),
            );
          },
        ),
      ),
    );
  }
}

