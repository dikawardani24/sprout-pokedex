extension StringExt on String {
  String get firstLetterUpperCase => this[0].toUpperCase() + substring(1).toLowerCase();

  String replaceScapeChars([String newChar = ' ']) =>
      replaceAll(RegExp(r'[\n\t\f]'), newChar).trim();

}