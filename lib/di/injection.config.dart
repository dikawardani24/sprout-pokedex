// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core/core.dart' as _i494;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pokedex/pokedex.dart' as _i706;

import '../pages/detail/bloc/detail_bloc.dart' as _i688;
import '../pages/home/bloc/home_bloc.dart' as _i752;
import '../repository/pokemon_repository.dart' as _i1049;
import '../usecase/get_detail_pokemon_use_case.dart' as _i353;
import '../usecase/get_info_about_use_case.dart' as _i190;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i1049.PokemonRepository>(
      () => _i1049.PokemonRepositoryImpl(gh<_i706.Pokedex>()));
  gh.factory<_i752.HomeBloc>(() => _i752.HomeBloc(
        gh<_i494.GetPokemonUseCase>(),
        gh<_i494.CacheImageUrlUseCase>(),
      ));
  gh.factory<_i190.GetInfoAboutUseCase>(
      () => _i190.GetInfoAboutUseCaseImpl(gh<_i1049.PokemonRepository>()));
  gh.factory<_i353.GetDetailPokemonUseCase>(
      () => _i353.GetDetailPokemonUseCaseImpl(gh<_i1049.PokemonRepository>()));
  gh.factory<_i688.DetailBloc>(() => _i688.DetailBloc(
        gh<_i190.GetInfoAboutUseCase>(),
        gh<_i353.GetDetailPokemonUseCase>(),
      ));
  return getIt;
}
