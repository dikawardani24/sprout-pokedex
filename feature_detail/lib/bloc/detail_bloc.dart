
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_detail/bloc/detail_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'detail_state.dart';

@injectable
class DetailBloc extends Bloc<DetailEvent, DetailState>{
  final GetDetailPokeUseCase _getDetailPokeUseCase;

  DetailBloc(this._getDetailPokeUseCase): super(const DetailState.initial()) {
    on<GetDetailEvent>(
      _getDetailPokemon,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );
  }

  Future<void> _getDetailPokemon(GetDetailEvent event, Emitter<DetailState> emit) async {
    emit(const DetailState.loading());
    try {
      final pokemon = await _getDetailPokeUseCase.execute(event.id);
      emit(DetailState.loaded(pokemon));
    } catch (err) {
      emit(DetailState.error(getErrorMessage(err)));
    }
  }
}