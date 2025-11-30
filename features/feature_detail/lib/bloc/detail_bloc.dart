
import 'package:core/core.dart';
import 'package:core/usecase/request/get_detail_req.dart';
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
    final result = await _getDetailPokeUseCase.execute(GetDetailReq(id: event.id));
    result.when(
        success: (data) =>  emit(DetailState.loaded(data)),
        error: (err) => emit(DetailState.error(getErrorMessage(err)))
    );
  }
}