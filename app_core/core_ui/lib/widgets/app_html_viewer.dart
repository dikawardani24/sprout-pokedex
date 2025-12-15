import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AppHtmViewer extends StatelessWidget {
  final String markdown;
  final Color textColor;

  const AppHtmViewer({super.key, required this.markdown, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: HtmlWidget(
        markdown,
        textStyle: TextStyle(fontSize: 16, color: textColor),
        customStylesBuilder: (element) {
          if (element.classes.contains('highlight')) {
            return {'color': 'red'};
          }
          return null;
        },
      ),
    );
  }
}