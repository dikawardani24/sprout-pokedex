import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_state.dart';
import 'package:sprout_pokedex/usecase/get_detail_pokemon_use_case.dart';
import 'package:sprout_pokedex/usecase/get_info_about_use_case.dart';

import 'about_state.dart';
import 'main_state.dart';

@injectable
class DetailCubit extends Cubit<DetailState> {
  final GetDetailPokemonUseCase _getDetailPokemonUseCase;
  final GetInfoAboutUseCase _getInfoAboutUseCase;

  DetailCubit(
      this._getDetailPokemonUseCase,
      this._getInfoAboutUseCase
  ): super(InitState());

  void getDetail(int id) async {
    emit(Loading());
    
    try {
      final pokemon = await _getDetailPokemonUseCase.execute(id);
      emit(ShowData(pokemon));
    } catch (_, trace) {
      emit(Error(trace));
    }
  }

  void getAboutInfo(Pokemon poke) async {
    emit(LoadingAboutState());

    try {
      final info = await _getInfoAboutUseCase.execute(poke);
      emit(ShowAboutState(aboutInfo: info));
    } catch (_, trace) {
      emit(ErrorAboutState(trace));
    }
  }
}