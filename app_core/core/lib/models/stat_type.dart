enum StatType {
  hp('hp', 255),
  attack('attack', 190),
  defense('defense', 230),
  specialAttack('special-attack', 194),
  specialDefense('special-defense', 230),
  speed('speed', 180),
  unknown("-", -1);

  final String map;
  final int max;

  const StatType(this.map, this.max);
}
