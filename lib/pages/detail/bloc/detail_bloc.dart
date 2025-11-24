
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_event.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_state.dart';
import 'package:sprout_pokedex/usecase/get_detail_pokemon_use_case.dart';
import 'package:sprout_pokedex/usecase/get_info_about_use_case.dart';
import 'package:sprout_pokedex/util/err_handler.dart';
import 'package:sprout_pokedex/util/event.dart';

@injectable
class DetailBloc extends Bloc<DetailEvent, DetailState>{
  final GetDetailPokemonUseCase _getDetailPokemonUseCase;
  final GetInfoAboutUseCase _getInfoAboutUseCase;

  DetailBloc(this._getInfoAboutUseCase, this._getDetailPokemonUseCase): super(const DetailState.initial()) {
    on<GetDetailEvent>(
      _getDetailPokemon,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );
  }

  Future<void> _getDetailPokemon(GetDetailEvent event, Emitter<DetailState> emit) async {
    emit(const DetailState.loading());
    try {
      final pokemon = await _getDetailPokemonUseCase.execute(event.id);
      final info = await _getInfoAboutUseCase.execute(pokemon);
      emit(DetailState.loaded(info));
    } catch (err) {
      emit(DetailState.error(getErrorMessage(err)));
    }
  }
}