extension StringExt on String {
  String get firstLetterUpperCase => this[0].toUpperCase() + substring(1).toLowerCase();
}