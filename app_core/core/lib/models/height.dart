import 'package:equatable/equatable.dart';
import 'package:pokedex/pokedex.dart';

class Height extends Equatable{
  final int value;

  const Height(this.value);
  double get inMeter => value / 10.0;

  int inInch() {
    final inch  = inMeter * 39.3701;
    return inch ~/ 12;
  }

  @override
  List<Object?> get props => [value];

  factory Height.from(Pokemon p) => Height(p.height);
}