
import 'formatter/poke_name_formatter.dart';

extension StringExt on String {
  String get firstLetterUpperCase => PokemonNameFormatter.format(this);

  String replaceScapeChars([String newChar = ' ']) =>
      replaceAll(RegExp(r'[\n\r\t\f\u2028\u2029]+'), newChar)
          .replaceAll('\u00AD', newChar)
          .replaceAll(RegExp(r'\s+'), newChar)
          .trim();

}