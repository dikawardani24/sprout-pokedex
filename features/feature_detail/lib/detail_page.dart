import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_detail/widgets/detail_landscape_desktop_widget.dart';
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

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  var _appBg = ColorRes.transparent;
  var _iconNavBackColor = ColorRes.black;
  var _color = ColorRes.white.withAlpha(20);
  var _showRefresh = false;

  bool get _isResizeable => AppConfig.isDesktop || AppConfig.isWeb;

  bool _isScreenTooSmall(BoxConstraints constraints) {
    int min = 200;

    if (_isResizeable) min = 400;
    return constraints.maxHeight < min || constraints.maxWidth < min;
  }

  PreferredSizeWidget _createAppBar(BuildContext c) => AppBar(
    leading: AppIconButton(
      icon: Icons.navigate_before,
      iconColor: _iconNavBackColor,
      onTap: () => c.goBack(),
    ),
    backgroundColor: _appBg,
    actions: [
      if (_showRefresh) AppIconButton(
        icon: Icons.refresh,
        iconColor: ColorRes.white,
        onTap: () => c.read<DetailBloc>().add(RefreshDetailEvent(widget.id)),
      )
    ],
  );

  Widget _buildLoaded(AppPokemonDetail info, BuildContext context, BoxConstraints constraints) {
    if (_isScreenTooSmall(constraints)) return AppErrorScreenSize();
    if (context.isBigScreen()) {
      if (_isResizeable) return DetailLandscapeDesktopWidget(detail: info);
      return DetailLandscape(detail: info);
    }
    return DetailPortrait(detail: info);
  }

  Widget _createBody() => SafeArea(
    child: BlocConsumer<DetailBloc, DetailState>(
        builder: (c, state) {
          return state.when(
              initial: () => const Loading(),
              loading: () => const Loading(),
              loaded: (info) => LayoutBuilder(
                builder: (context, constraints) => _buildLoaded(info, context, constraints),
              ),
              error: (message) => AppErrorWidget(message: message)
          );
        },
        listener: (c, state) {
          state.whenOrNull(
              loaded: (info) => setState(() {
                final colorDex = info.color;
                _appBg = colorDex.secondary;
                _color = colorDex.primary.withAlpha(50);
                _iconNavBackColor = ColorRes.white;
                _showRefresh = true;

              })
          );
        }
    ),
  );

  Widget _createImageHeader() => LayoutBuilder(
    builder: (c, a) {
      Alignment alignment = Alignment.topRight;
      if (c.isBigScreen()) alignment = Alignment.topLeft;
      return AppAnimateRotateImg(
        isShow: !_isScreenTooSmall(a),
        alignment: alignment,
        color: _color,
      );
    }
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => GetIt.I.get<DetailBloc>()..add(GetDetailEvent(widget.id)),
      child: Builder(
        builder: (c) {
          return Stack(
            children: [
              Scaffold(
                appBar: _createAppBar(c),
                body: _createBody(),
              ),
              _createImageHeader()
            ],
          );
        },
      ),
    );
  }
}