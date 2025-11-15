// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pokedex/pokedex.dart' as _i706;

import '../pages/home/bloc/home_bloc.dart' as _i752;
import '../repository/pokemon_repository.dart' as _i1049;
import '../usecase/GetPokemonUseCase.dart' as _i983;
import 'network_module.dart' as _i567;

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
  final networkModule = _$NetworkModule();
  gh.singleton<_i706.Pokedex>(() => networkModule.pokedex);
  gh.factory<_i1049.PokemonRepository>(
      () => _i1049.PokemonRepositoryImpl(gh<_i706.Pokedex>()));
  gh.factory<_i983.GetPokemonUseCase>(
      () => _i983.GetPokemonUseCaseImpl(gh<_i1049.PokemonRepository>()));
  gh.factory<_i752.HomeBloc>(
      () => _i752.HomeBloc(gh<_i983.GetPokemonUseCase>()));
  return getIt;
}

class _$NetworkModule extends _i567.NetworkModule {}
