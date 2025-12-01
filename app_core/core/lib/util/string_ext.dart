
import 'formatter/poke_name_formatter.dart';

extension StringExt on String {
  String get firstLetterUpperCase => PokemonNameFormatter.format(this);

  String replaceScapeChars([String newChar = ' ']) =>
      replaceAll(RegExp(r'[\n\t\f]'), newChar).trim();

}