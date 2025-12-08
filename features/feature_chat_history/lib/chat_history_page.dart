import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_chat_history/bloc/chat_history_bloc.dart';
import 'package:feature_chat_history/bloc/chat_history_event.dart';
import 'package:feature_chat_history/bloc/chat_history_state.dart';
import 'package:feature_chat_history/widgets/item_chat_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChatHistoryPage extends StatelessWidget {

  const ChatHistoryPage({super.key});

  void _showNotifHistoryDeleted(BuildContext context) =>
      context.showSuccessSnackBar(StringRes.historyDeletedSuccess);

  void _showConfirmation(BuildContext context, ChatHistory history) =>
      context.showConfirmationDialog(
        message: StringRes.questionDeleteChatHistory,
        onConfirmed: () => context.read<ChatHistoryBloc>().add(DeleteHistoryEvent(chatHistory: history))
      );

  Widget _buildLoadingIndicator() => const SliverToBoxAdapter(
      child: Loading()
  );

  Widget _buildErr(String err) => SliverToBoxAdapter(
    child: Text(err, style: TextStyle(
        color: ColorRes.red,
        fontWeight: FontWeight.bold
    )),
  );

  Widget _buildItems(BuildContext context, List<ChatHistory> list) =>  SliverList(
    delegate: SliverChildBuilderDelegate((c, index) => Padding(
      padding: EdgeInsetsGeometry.only(bottom: DimenRes.size_10),
      child: ItemChatHistory(
        chatHistory: list[index],
        onSelectHistory: (history) => context.goBack(history),
        onDeleteAction: () => _showConfirmation(context, list[index]),
      ),
    ), childCount: list.length),
  );

  Widget _buildEndOfItem(BuildContext context) => SliverToBoxAdapter(
    child: Center(
      child: Text(
        StringRes.allChatHistoryLoaded,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    ),
  );

  Widget _buildNoData(BuildContext context) => SliverFillRemaining(
    child:AppErrorWidget(
      message: StringErrRes.errNoChatHistory,
    ),
  );

  Widget _buildContent(BuildContext context, List<ChatHistory> list, {
    bool isLoadMore = false,
    bool isReachMax = false,
    String? err
  }) {
    if (context.isSmallScreen())  return AppErrorScreenSize();

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.all(DimenRes.size_16),
        child: CustomScrollView(
          slivers: [
            _buildItems(context, list),
            if (list.isEmpty) _buildNoData(context),
            if (isLoadMore) _buildLoadingIndicator(),
            if (err != null) _buildErr(err),
            if (isReachMax) _buildEndOfItem(context)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton.noBackground(
          icon: IconRes.iconNavBack,
          iconColor: context.iconThemColor,
          onTap: context.goBack,
        ),
        title: Text(StringRes.chatHistory,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider<ChatHistoryBloc>(
        create: (_) => GetIt.I.get<ChatHistoryBloc>()..add(GetHistoryEvent(isLoadMore: false)),
        child: BlocConsumer<ChatHistoryBloc, ChatHistoryState>(
          listener: (c, state) {
            state.whenOrNull(
              errDeleteHistory: (err) => c.showErrorSnackBar(err),
              historyDeleted: (_) => _showNotifHistoryDeleted(c)
            );
          },
          builder: (c, state) => state.maybeWhen(
              loading: () => Loading(),
              loadingMore: (data) => _buildContent(c, data, isLoadMore: true),
              loaded: (data, isReachMax) => _buildContent(c, data, isReachMax: isReachMax),
              loadMoreError: (data, err) => _buildContent(c, data, err: err),
              error: (err) => AppErrorWidget(message: err),
              historyDeleted: (data) => _buildContent(c, data),
              orElse: () => _buildContent(c, [])
          ),
        ),
      ),
    );
  }
}