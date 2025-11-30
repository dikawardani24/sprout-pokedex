import 'package:equatable/equatable.dart';

class AppPage<T> extends Equatable{
  final List<T> data;
  final bool isReachMaxLimit;
  final int limit;

  const AppPage({
    required this.data,
    required this.isReachMaxLimit,
    required this.limit
  });

  @override
  List<Object?> get props => [data, isReachMaxLimit, limit];
}