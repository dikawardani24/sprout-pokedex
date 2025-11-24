import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {}

class GetDetailEvent extends DetailEvent {
  final int id;

  GetDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}