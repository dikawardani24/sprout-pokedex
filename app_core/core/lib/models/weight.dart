import 'package:equatable/equatable.dart';
import 'package:pokedex/pokedex.dart';

class Weight extends Equatable {
  final int value;

  const Weight(this.value);

  double get inKg => value / 10.0;
  double get inPounds => inKg * 2.20462;

  @override
  List<Object?> get props => [value];

  factory Weight.from(Pokemon p) => Weight(p.weight);
}