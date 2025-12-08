import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_home/bloc/home_bloc.dart';
import 'package:feature_home/bloc/home_event.dart';
import 'package:feature_home/bloc/home_state.dart';
import 'package:feature_home/widget/pokemon_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

typedef OnStartDetail = void Function(BuildContext context, AppPokemon selected);
typedef OnStartChat = void Function(BuildContext context);

class HomePage extends StatefulWidget {
  final OnStartDetail? onStartDetail;
  final OnStartChat? onStartChat;

  const HomePage({
    super.key,
    this.onStartDetail,
    this.onStartChat
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  late final HomeBloc _homeBloc;

  void _initPokemon(BuildContext context) {
    if (_homeBloc.state.isLoading) return;
    _homeBloc.add(GetPokemonsEvent(isLoadMore: false));
  }

  Widget _buildPokemonList({
    required BuildContext context,
    required List<AppPokemon> pokemons,
    bool isLoadingMore = false,
    bool hasReachedMax = false,
    String? errorMessage,
  }) {
    return Stack(
      children: [
        PokemonList(
          pokemons: pokemons,
          isLoadingMore: isLoadingMore,
          hasReachedMax: hasReachedMax,
          errorMessage: errorMessage,
          onStartDetail: (selected) {widget.onStartDetail?.call(this.context, selected);},
          onRetry: () => _initPokemon(context),
          scrollController: _controller,
        ),
        ScrollTopContainer(
          scrollController: _controller,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _homeBloc = GetIt.I.get<HomeBloc>();
    _homeBloc.add(GetPokemonsEvent(isLoadMore: false));

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    final threshold = maxScroll * 0.9; // Load more at 90% scroll
    
    if (currentScroll >= threshold) {
      _homeBloc.add(GetPokemonsEvent(isLoadMore: true));
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _homeBloc..clearState()..close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: AppIconButton(
        icon: IconRes.iconChat,
        iconColor: ColorRes.white,
        backgroundColor: ColorRes.red,
        onTap: () => widget.onStartChat?.call(this.context),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          builder: (context, state) {
            return state.when(
              initial: () => Container(),
              loading: () => const Loading(),
              loadingMore: (pokemons) => _buildPokemonList(
                context: context,
                pokemons: pokemons,
                isLoadingMore: true,
              ),
              loaded: (pokemons, hasReachedMax) => _buildPokemonList(
                context: context,
                pokemons: pokemons,
                hasReachedMax: hasReachedMax,
              ),
              error: (msg) => AppErrorWidget(
                message: msg,
                onRetry: () => _initPokemon(context),
              ),
              loadMoreError: (pokemons, msg) => AppErrorWidget(
                message: msg,
                onRetry: () => _initPokemon(context),
              ),
            );
          },
        ),
      ),
    );
  }
}