class PokemonNameFormatter {
  static String format(String name) {
    if (name.isEmpty) return name;

    // Remove dashes and replace with spaces
    final withoutDashes = name.replaceAll('-', ' ');

    // Capitalize first letter of each word
    return withoutDashes.split(' ').map((word) {
      if (word.isEmpty) return word;

      // Handle special cases
      if (word == 'mr') return 'Mr';
      if (word == 'mime') return 'Mime';
      if (word == 'jr') return 'Jr';

      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Alternative: Only capitalize first letter of entire string
  static String formatSimple(String name) {
    if (name.isEmpty) return name;

    final withoutDashes = name.replaceAll('-', ' ');
    return withoutDashes[0].toUpperCase() + withoutDashes.substring(1).toLowerCase();
  }
}

extension StringExt on String {
  String get firstLetterUpperCase => PokemonNameFormatter.format(this);

  String replaceScapeChars([String newChar = ' ']) =>
      replaceAll(RegExp(r'[\n\t\f]'), newChar).trim();

}