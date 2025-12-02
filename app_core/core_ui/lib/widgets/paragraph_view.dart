import 'package:flutter/material.dart';

class ParagraphView extends StatelessWidget {
  final List<String> list;
  final Color color;

  const ParagraphView({super.key, required this.list, required this.color});

  List<List<String>> _chunkList(List<String> items, int size) {
    List<List<String>> chunks = [];
    for (var i = 0; i < items.length; i += size) {
      final chunk = items.sublist(
        i,
        i + size > items.length ? items.length : i + size,
      );
      chunks.add(
        chunk
      );
    }
    return chunks;
  }

  List<String> paragraphs() {
    List<String> par = [];

    _chunkList(list, 5).forEach((e) {
      for (var i=0; i<e.length; i++) {
        if (i == 0) {
          par.add("${e[i]}\n\n");
          continue;
        }
        par.add(e[i]);
      }
    });

    return par;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      paragraphs().join(" "),
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: color
      ),
    );
  }

}