import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class AppMarkdown extends StatelessWidget{
  final String textMarkdown;

  const AppMarkdown({super.key, required this.textMarkdown});

  @override
  Widget build(BuildContext context) {
    return GptMarkdown(textMarkdown);
  }

}