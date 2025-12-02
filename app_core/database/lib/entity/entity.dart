import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  Object get primaryKey;
  Map<String, dynamic> toMap();
}

