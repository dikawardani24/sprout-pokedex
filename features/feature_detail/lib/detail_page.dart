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

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  var _appBg = ColorRes.transparent;
  var _iconNavBackColor = ColorRes.black;
  var _showRefresh = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  bool _isScreenTooSmall(BoxConstraints constraints) {
    int min = 400;
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

  Widget _createBody() => SafeArea(
    child: BlocConsumer<DetailBloc, DetailState>(
        builder: (c, state) {
          return state.when(
              initial: () => const Loading(),
              loading: () => const Loading(),
              loaded: (info) => LayoutBuilder(
                builder: (context, constraints) {
                  if (_isScreenTooSmall(constraints)) return AppErrorScreenSize();
                  if (context.isBigScreen()) return DetailLandscape(detail: info);
                  return DetailPortrait(detail: info);
                },
              ),
              error: (message) => AppErrorWidget(message: message)
          );
        },
        listener: (c, state) {
          state.whenOrNull(
              loaded: (info) => setState(() {
                _appBg = info.color.secondary;
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
      if (c.isBigScreen()) alignment = Alignment.bottomLeft;
      return AppAnimateRotateImg(
        boxConstraints: a,
        isShow: !_isScreenTooSmall(a),
        alignment: alignment,
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