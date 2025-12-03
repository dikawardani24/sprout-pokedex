// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core/core.dart' as _i494;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../bloc/home_bloc.dart' as _i997;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initFeatureHome(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i997.HomeBloc>(
    () => _i997.HomeBloc(
      gh<_i494.GetPokemonUseCase>(),
      gh<_i494.CacheImageUrlUseCase>(),
    ),
  );
  return getIt;
}
