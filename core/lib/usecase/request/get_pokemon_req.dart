import 'package:core/usecase/use_case.dart';

class GetPokemonReq implements Request{
  final int limit;
  final int offset;

  const GetPokemonReq({required this.limit, required this.offset});
}