// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:api/datasource/pokemon_datasource.dart' as _i946;
import 'package:app_preference/app_preference.dart' as _i669;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:database/database.dart' as _i252;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../repository/impl/pokemon_local_repository_impl.dart' as _i914;
import '../repository/impl/pokemon_remote_repository_impl.dart' as _i792;
import '../repository/pokemon_local_repository.dart' as _i499;
import '../repository/pokemon_remote_repository.dart' as _i930;
import '../service/impl/network_service_impl.dart' as _i603;
import '../service/network_service.dart' as _i724;
import '../usecase/cache_image_url_use_case.dart' as _i1054;
import '../usecase/get_detail_poke_use_case.dart' as _i964;
import '../usecase/get_pokemon_use_ase.dart' as _i898;
import '../usecase/validate_connection_use_case.dart' as _i290;
import 'core_module.dart' as _i154;

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
  final coreModule = _$CoreModule();
  gh.singleton<_i895.Connectivity>(() => coreModule.connectivity);
  gh.factory<_i1054.CacheImageUrlUseCase>(
      () => _i1054.CacheImageUrlUseCaseImpl());
  gh.factory<_i724.NetworkService>(
      () => _i603.NetworkServiceImpl(connectivity: gh<_i895.Connectivity>()));
  gh.factory<_i499.PokemonLocalRepository>(
      () => _i914.PokemonLocalRepositoryImpl(gh<_i252.PokemonDatasource>()));
  gh.factory<_i930.PokemonRemoteRepository>(
      () => _i792.PokemonRemoteRepositoryImpl(gh<_i946.PokemonDatasource>()));
  gh.factory<_i290.ValidateConnectionUseCase>(
      () => _i290.ValidateConnectionUseCaseImpl(gh<_i724.NetworkService>()));
  gh.factory<_i964.GetDetailPokeUseCase>(() => _i964.GetDetailPokeUseCaseImpl(
        gh<_i930.PokemonRemoteRepository>(),
        gh<_i499.PokemonLocalRepository>(),
        gh<_i290.ValidateConnectionUseCase>(),
      ));
  gh.factory<_i898.GetPokemonUseCase>(() => _i898.GetPokemonUseCaseImpl(
        gh<_i930.PokemonRemoteRepository>(),
        gh<_i499.PokemonLocalRepository>(),
        gh<_i669.DataValidityPref>(),
        gh<_i290.ValidateConnectionUseCase>(),
      ));
  return getIt;
}

class _$CoreModule extends _i154.CoreModule {}
