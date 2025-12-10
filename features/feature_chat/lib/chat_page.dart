import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';
import 'widget/app_chat_input.dart';
import 'widget/chat_widget.dart';

typedef OnStartChatHistory = Future<dynamic> Function(BuildContext context);
typedef OnStartSetApiKey = Future<dynamic> Function(BuildContext context);

class ChatPage extends StatefulWidget {
  final int? pokemonId;
  final OnStartChatHistory? onStartChatHistory;
  final OnStartSetApiKey? onStartSetApiKey;

  const ChatPage({
    super.key,
    this.pokemonId,
    this.onStartChatHistory,
    this.onStartSetApiKey
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isStream = true;
  late ChatBloc _bloc;

  void _startSetApiKeyPage(BuildContext context) {
    widget.onStartSetApiKey?.call(this.context).then((isApiKeySaved) {
      if (isApiKeySaved is bool && isApiKeySaved) {
        _bloc.add(InitChatEvent(widget.pokemonId, DateTime.now()));
      }
    });
  }

  void _startHistoryPage(BuildContext context) {
    widget.onStartChatHistory?.call(context).then((result) {
      _bloc.add(LoadHistoryChatEvent(result));
    });
  }

  void _askQuestion(BuildContext context, String question) {
    context.dismissKeyboard();
    _bloc.add(AskQuestionEvent(question, isStream: _isStream));
  }
  
  void _toggleStreamAnswer() {
    setState(() {
      _isStream = !_isStream;
    });
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
        onTap: () => _startHistoryPage(context),
      )
    ],
  );

  Widget _buildContent(BuildContext context, {
    List<ChatMessage> list = const [],
    bool isLoadingAnswer = false,
    String? err,
    AppPokemonDetail? detail,
    bool isLoadingHistory = false,
    bool isAiApiKeySet = true
  }) {
    if (isLoadingHistory) return Loading();

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            ImageRes.pokeBall,
            color: ColorRes.grey.withAlpha(20),
          ),
        ),
        if (list.isEmpty && isAiApiKeySet) Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsetsGeometry.all(DimenRes.size_16),
            child: LayoutBuilder(
              builder: (c, constraint) {
                if (detail != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: DimenRes.size_16,
                    children: [
                      AppNetworkImage(
                        imageUrl: detail.imageUrl,
                        imageSize: DimenRes.size_100,
                        imageErrSize: DimenRes.size_100,
                      ),
                      Text(StringRes.greetChatWithTopic(detail.name), textAlign: TextAlign.center)
                    ],
                  );
                }
                return Text(StringRes.greetChat, textAlign: TextAlign.center);
              },
            ),
          ),
        ),
        if (!isAiApiKeySet) AppErrorWidget(
          message: StringErrRes.errNoAiApiKey,
          titleBtn: StringRes.setGeminiApiKey,
          onRetry: () => _startSetApiKeyPage(context),
        ),
        if (isAiApiKeySet) Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (_, index) {
                  final message =list[index];
                  return ChatWidget(chatMessage: message);
                },
              ),
            ),
            if (err != null) Text(err,
              style: TextStyle(color: ColorRes.red, fontSize: DimenRes.size_12),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: DimenRes.size_16, left: DimenRes.size_16, right: DimenRes.size_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: DimenRes.size_10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: DimenRes.size_10,
                    children: [
                      if (isLoadingAnswer) Expanded(
                        flex: 1,
                        child: AppChatBubble(
                          dotColor: ColorRes.red,
                          dotSize: DimenRes.size_16,
                        ),
                      ),
                      Checkbox(value: _isStream, onChanged: (_) => _toggleStreamAnswer()),
                      Text(StringRes.realTime)
                    ],
                  ),
                  AppChatInput(
                    allowSendNewChat: !isLoadingAnswer,
                    onTapSendQuestion: (q) => _askQuestion(context, q),
                  ),
                  if (err != null) AppButton(
                    label: StringRes.changeApiKey,
                    onPressed: () => _startSetApiKeyPage(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    _bloc = GetIt.I.get<ChatBloc>()..add(InitChatEvent(widget.pokemonId, DateTime.now()));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: _bloc,
        listener: (context, state) {
          state.maybeWhen(
            gotAnswered: (_) => _scrollToBottom(),
            questionAdded: (_) => _scrollToBottom(),
            answered: (_) => _scrollToBottom(),
            errGetMessageByHistory: (err) => context.showErrorSnackBar(err),
            historySaved: (_) => _startHistoryPage(context),
            noHistoryToBeSave: (_) => _startHistoryPage(context),
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            gotAnswered: (messages) => _buildContent(context, list: messages, isLoadingAnswer: true),
            questionAdded: (messages) => _buildContent(context, list: messages, isLoadingAnswer: true),
            answered: (messages) => _buildContent(context, list: messages),
            errorGetAnswer: (err, messages) => _buildContent(context, list: messages, err: StringErrRes.errGetAnswerAi),
            notAnswered: (messages) => _buildContent(context, list: messages, err: StringErrRes.errGetAnswerAi),
            loadingGetDetailPokemon: () => _buildContent(context, isLoadingAnswer: true),
            gotDetailPokemon: (data, isAiApiKeySet) => _buildContent(context, isLoadingAnswer: false, detail: data, isAiApiKeySet: isAiApiKeySet),
            gotMessageByHistory: (data) => _buildContent(context, list: data),
            loadingSaveHistory: (data) => _buildContent(context, list: data, isLoadingHistory: true),
            orElse: () => _buildContent(context),
          );
        },
      ),
    );
  }
}

