import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_cubit.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_state.dart';
import 'package:sprout_pokedex/pages/detail/bloc/main_state.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_content.dart';
import 'package:sprout_pokedex/pages/error_page.dart';
import 'package:sprout_pokedex/pages/loading_page.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({
    super.key,
    required this.id
  });

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var _appBg = ColorRes.transparent;
  var _iconNavBackColor = ColorRes.black;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => GetIt.I.get<DetailCubit>()..getDetail(widget.id),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: _iconNavBackColor),
              backgroundColor: _appBg,
            ),
            body: SafeArea(
              child: BlocListener<DetailCubit, DetailState>(
                child: BlocBuilder<DetailCubit, DetailState>(
                  builder: (c, state) {
                    if (state is Loading) return const LoadingPage();
                    if (state is Error) return const ErrorPage();
                    if (state is ShowData) return DetailContent(pokemon: state.pokemon,);
                    return Container();
                  },
                ),
                listener: (c, state) {
                  if (state is ShowData) {
                    setState(() {
                      _appBg = state.pokemon.pokedexTypeColor.secondary;
                      _iconNavBackColor = ColorRes.white;
                    });
                  }
                }
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(ImageRes.pokeBall,
              color: ColorRes.white.withAlpha(20),
            ),
          )
        ],
      ),
    );
  }
}