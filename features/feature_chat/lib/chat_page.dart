import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_chat/widget/chat_action.dart';
import 'package:feature_chat/widget/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';

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
  late ChatBloc _bloc;
  ChatType _chatType = ChatType.stream;
  bool _isShowNewChat = false;

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
    _bloc.add(AskQuestionEvent(question, isStream: _chatType == ChatType.stream));
  }

  void _showNewChat(bool show) {
    if (show == _isShowNewChat) return;
    setState(() {
      _isShowNewChat = show;
    });
  }

  void _startNewChat() {
    _bloc.add(StartNewChatEvent(DateTime.now()));
    _showNewChat(false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        _showNewChat(false);
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ).then((_) => _showNewChat(true));
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
      if (_isShowNewChat) TextButton(
        onPressed: () => _startNewChat(),
        child: Row(
          spacing: DimenRes.size_10,
          children: [
            Icon(IconRes.iconNewChat),
            Text(StringRes.newChat)
          ],
        ),
      ),
      AppIconButton.noBackground(
        icon: IconRes.iconHistory,
        iconColor: context.iconThemColor,
        onTap: () => _startHistoryPage(context),
      )
    ],
  );

  Widget _buildChat({
    List<ChatMessage> list = const [],
    String? err,
    bool isLoadingAnswer = false,
    AppPokemonDetail? detail
  }) {
    return Column(
      spacing: DimenRes.size_16,
      children: [
        Expanded(
          child: ChatList(
            messages: list,
            detail: detail,
            controller: _scrollController,
          ),
        ),
        ChatAction(
          chatType: _chatType,
          err: err,
          onStartSetApiKey: () => widget.onStartSetApiKey?.call(context),
          state: isLoadingAnswer ? ChatActionState.loading: ChatActionState.idle,
          onTapSendQuestion: (q) => _askQuestion(context, q),
          onTapSetApiKey: () => _startSetApiKeyPage(context),
          onChangeChatType: (type) {
            setState(() {
              _chatType = type;
            });
          },
        )
      ],
    );
  }

  Widget _buildContent(BuildContext context, {
    List<ChatMessage> list = const [],
    bool isLoadingAnswer = false,
    String? err,
    AppPokemonDetail? detail,
    bool isLoadingHistory = false,
    bool isAiApiKeySet = true
  }) {
    if (isLoadingHistory) return Loading();
    if (!isAiApiKeySet) {
      return AppErrorWidget(
        message: StringErrRes.errNoAiApiKey,
        titleBtn: StringRes.setGeminiApiKey,
        onRetry: () => _startSetApiKeyPage(context),
      );
    }
    return _buildChat(
        list: list,
        isLoadingAnswer: isLoadingAnswer,
        err: err,
        detail: detail
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
    return AppPageWidget(
      appBar: _buildAppBar(context),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: _bloc,
        listener: (context, state) {
          state.maybeWhen(
            gotAnswered: (_) => _scrollToBottom(),
            questionAdded: (_) => _scrollToBottom(),
            answered: (_) => _scrollToBottom(),
            errGetMessageByHistory: (err) => context.showErrorSnackBar(err),
            // noHistoryToBeSave: (_) => _startHistoryPage(context),
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

