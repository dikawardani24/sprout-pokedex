import 'package:feature_set_ai_api_key/bloc/set_api_key_bloc.dart';
import 'package:feature_set_ai_api_key/bloc/set_api_key_event.dart';
import 'package:feature_set_ai_api_key/bloc/set_api_key_state.dart';
import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SetAiApiKeyPage extends StatefulWidget {

  const SetAiApiKeyPage({super.key});

  @override
  State<SetAiApiKeyPage> createState() => _SetAiApiKeyPageState();
}

class _SetAiApiKeyPageState extends State<SetAiApiKeyPage> {
  late TextEditingController _controller;
  late SetApiKeyBloc _bloc;

  void _save(BuildContext c) {
    final apiKey = _controller.text;
    _bloc.add(SaveApiKeyEvent(apiKey));
  }

  void _goBackWithResult(BuildContext c, bool isApiKeySaved) {
    if (isApiKeySaved) c.showSuccessSnackBar(StringRes.apiKeySaved);
    c.goBack(isApiKeySaved);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    title: Text(StringRes.setGeminiApiKey, style: TextStyle(color: context.iconThemColor),),
    leading: AppIconButton.noBackground(
      icon: IconRes.iconNavBack,
      iconColor: context.iconThemColor,
      onTap: () => _goBackWithResult(context, false),
    )
  );

  Widget _buildDescription(BuildContext context) {
    return Text(
      StringRes.descSetApiKey,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: DimenRes.size_12,
      ),
    );
  }

  Widget _buildInput(BuildContext context) => Column(
    spacing: DimenRes.size_16,
    children: [
      _buildDescription(context),
      AppInputField(textInputType: TextInputType.multiline, controller: _controller,),
    ],
  );

  Widget _buildContent(BuildContext context, {bool isLoading = false}) {
    if (isLoading) return Loading();
    return Column(
      spacing: DimenRes.size_16,
      children: [
        Expanded(child: _buildInput(context)),
        AppButton(label: StringRes.save, onPressed: () => _save(context)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageWidget(
      appBar: _buildAppBar(context),
      body: BlocConsumer<SetApiKeyBloc, SetApiKeyState>(
        bloc: _bloc,
        listener: (c, state) {
          state.whenOrNull(
              apiKeySaved: () => _goBackWithResult(c, true),
              errSaveApiKey: (err) => c.showErrorSnackBar(err)
          );
        },
        builder: (c, state) {
          return state.maybeWhen(
              loadingSaveApiKey: () => _buildContent(c, isLoading: true),
              orElse: () => _buildContent(c)
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _bloc = GetIt.I.get<SetApiKeyBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}