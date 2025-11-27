// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pokedex/pokedex.dart' as _i706;

import '../datasource/pokemon_datasource.dart' as _i176;
import '../repository/pokemon_repository.dart' as _i1049;
import '../usecase/cache_image_url_use_case.dart' as _i1054;
import '../usecase/get_detail_poke_use_case.dart' as _i964;
import '../usecase/get_pokemon_use_ase.dart' as _i898;
import 'network_module.dart' as _i567;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initCore(
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
  gh.factory<_i1054.CacheImageUrlUseCase>(
      () => _i1054.CacheImageUrlUseCaseImpl());
  gh.factory<_i176.PokemonDatasource>(
      () => _i176.PokemonDatasourceImpl(gh<_i706.Pokedex>()));
  gh.factory<_i1049.PokemonRepository>(
      () => _i1049.PokemonRepositoryImpl(gh<_i176.PokemonDatasource>()));
  gh.factory<_i964.GetDetailPokeUseCase>(
      () => _i964.GetDetailPokeUseCaseImpl(gh<_i1049.PokemonRepository>()));
  gh.factory<_i898.GetPokemonUseCase>(
      () => _i898.GetPokemonUseCaseImpl(gh<_i1049.PokemonRepository>()));
  return getIt;
}

class _$NetworkModule extends _i567.NetworkModule {}
