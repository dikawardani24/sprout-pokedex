class PokemonNameFormatter {
  static String format(String name) {
    if (name.isEmpty) return name;

    final withoutDashes = name.replaceAll('-', ' ');

    return withoutDashes.split(' ').map((word) {
      if (word.isEmpty) return word;

      if (word == 'mr') return 'Mr';
      if (word == 'mime') return 'Mime';
      if (word == 'jr') return 'Jr';

      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static String formatSimple(String name) {
    if (name.isEmpty) return name;

    final withoutDashes = name.replaceAll('-', ' ');
    return withoutDashes[0].toUpperCase() + withoutDashes.substring(1).toLowerCase();
  }
}