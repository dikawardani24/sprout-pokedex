import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

class SetAiApiKeyPage extends StatelessWidget {

  const SetAiApiKeyPage({super.key});

  void _save() {}

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    leading: AppIconButton.noBackground(
      icon: IconRes.iconNavBack,
      iconColor: context.iconThemColor,
      onTap: context.goBack,
    )
  );

  Widget _buildHeader(BuildContext context) {
    return Text(
      StringRes.titleSetApiKey,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: DimenRes.size_16,
        fontWeight: FontWeight.bold
      ),
    );
  }

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
      _buildHeader(context),
      _buildDescription(context),
      AppInputField(textInputType: TextInputType.multiline),
    ],
  );

  Widget _buildContent(BuildContext context) {
    bool isScreenSmall = context.isSmallScreen();

    if (isScreenSmall) return AppErrorScreenSize();

    return Column(
      spacing: DimenRes.size_16,
      children: [
        Expanded(child: _buildInput(context)),
        AppButton(label: StringRes.save, onPressed: _save),
        AppButton(label: StringRes.cancel, onPressed: () => context.goBack())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsetsGeometry.all(DimenRes.size_16),
        child: _buildContent(context),
      ),
    );
  }

}