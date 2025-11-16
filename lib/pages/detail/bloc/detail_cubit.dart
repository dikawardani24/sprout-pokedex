import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_state.dart';
import 'package:sprout_pokedex/usecase/get_detail_pokemon_use_case.dart';

@injectable
class DetailCubit extends Cubit<DetailState> {
  final GetDetailPokemonUseCase _getDetailPokemonUseCase;
  
  DetailCubit(this._getDetailPokemonUseCase): super(InitState());

  void getDetail(int id) async {
    emit(Loading());
    
    try {
      final pokemon = await _getDetailPokemonUseCase.execute(id);
      emit(ShowData(pokemon));
    } catch (_, trace) {
      emit(Error(trace));
    }
  }
}