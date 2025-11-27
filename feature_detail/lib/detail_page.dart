import 'package:core_ui/core_ui.dart';
import 'package:feature_detail/widgets/detail_landscape_widget.dart';
import 'package:feature_detail/widgets/detail_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'bloc/detail_bloc.dart';
import 'bloc/detail_event.dart';
import 'bloc/detail_state.dart';

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
    Alignment alignment = Alignment.topRight;

    if (context.isBigScreen()) alignment = Alignment.bottomLeft;

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
                        loaded: (info) => LayoutBuilder(
                          builder: (context, constraints) {
                            if (context.isBigScreen())  return DetailLandscape(detail: info);
                            return DetailPortrait(detail: info);
                          },
                        ),
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
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            alignment: alignment,
            child: Image.asset(ImageRes.pokeBall,
              color: ColorRes.white.withAlpha(20),
            ),
          )
        ],
      ),
    );
  }
}