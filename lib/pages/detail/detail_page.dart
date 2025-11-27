import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_bloc.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_event.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_state.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_content.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/widgets/loading.dart';

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
      create: (c) => GetIt.I.get<DetailBloc>()..add(GetDetailEvent(widget.id)),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: _iconNavBackColor),
              backgroundColor: _appBg,
            ),
            body: SafeArea(
              child: BlocConsumer<DetailBloc, DetailState>(
                  builder: (c, state) {
                    return state.when(
                        initial: () => const Loading(),
                        loading: () => const Loading(),
                        loaded: (info) => DetailContent(detail: info),
                        error: (message) => ErrorWidget(message)
                    );
                  },
                  listener: (c, state) {
                    state.whenOrNull(
                      loaded: (info) => setState(() {
                        _appBg = info.pokedexTypeColor.secondary;
                        _iconNavBackColor = ColorRes.white;
                      })
                    );
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