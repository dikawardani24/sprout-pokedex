import 'package:flutter/material.dart';

import '../res/color_res.dart';
import '../res/dimen_res.dart';

class AppLongDesc extends StatefulWidget{
  final String desc;
  final Color textColor;

  const AppLongDesc({super.key, required this.desc, required this.textColor});

  @override
  State<AppLongDesc> createState() => _AppLongDescState();
}

class _AppLongDescState extends State<AppLongDesc> {
  bool _showReadMore = true;

  String get _titleButton {
    if (_showReadMore) return "Read more";
    return "Hide";
  }

  void _updateState() => setState(() {
    _showReadMore = !_showReadMore;
  });

  Widget _buildText() {
    int? maxLine;
    TextOverflow? textOverflow;

    if (_showReadMore) {
      maxLine = 2;
      textOverflow = TextOverflow.ellipsis;
    }

    return Text(widget.desc,
      textAlign: TextAlign.justify,
      style: TextStyle(color: ColorRes.black),
      maxLines: maxLine,
      overflow: textOverflow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: DimenRes.size_8,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildText(),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: widget.textColor.withAlpha(80)
          ),
          onPressed: _updateState,
          child: Text(_titleButton,
            style: TextStyle(
              color: widget.textColor
            ),
          ),
        )
      ],
    );
  }
}