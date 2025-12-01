import 'package:core/usecase/use_case.dart';

class GetPokemonReq implements Request{
  final int offset;

  const GetPokemonReq({required this.offset});
}