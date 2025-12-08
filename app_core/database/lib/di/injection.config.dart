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

import '../datasource/chat_history_datasource.dart' as _i45;
import '../datasource/chat_message_datasource.dart' as _i348;
import '../datasource/impl/chat_history_datasource_impl.dart' as _i410;
import '../datasource/impl/chat_message_datasource_impl.dart' as _i698;
import '../datasource/impl/pokemon_datasource_impl.dart' as _i352;
import '../datasource/impl/pokemon_detail_datasource_impl.dart' as _i668;
import '../datasource/pokemon_datasource.dart' as _i176;
import '../datasource/pokemon_detail_datasource.dart' as _i551;
import '../db_init.dart' as _i170;
import '../db_open_helper.dart' as _i826;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initDatabase(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i170.DbInit>(() => _i170.DbInit());
  gh.factory<_i826.DbOpenHelper>(() => _i826.DbOpenHelper(gh<_i170.DbInit>()));
  gh.factory<_i348.ChatMessageDatasource>(
    () => _i698.ChatMessageDatasourceImpl(gh<_i826.DbOpenHelper>()),
  );
  gh.factory<_i551.PokemonDetailDatasource>(
    () => _i668.PokemonDetailDatasourceImpl(gh<_i826.DbOpenHelper>()),
  );
  gh.factory<_i45.ChatHistoryDatasource>(
    () => _i410.ChatHistoryDatasourceImpl(gh<_i826.DbOpenHelper>()),
  );
  gh.factory<_i176.PokemonDatasource>(
    () => _i352.PokemonLocalDatasourceImpl(gh<_i826.DbOpenHelper>()),
  );
  return getIt;
}
