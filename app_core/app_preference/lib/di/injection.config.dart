// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../preference/ai_api_key_pref.dart' as _i821;
import '../preference/data_validity_pref.dart' as _i763;
import '../preference/impl/ai_api_key_pref_impl.dart' as _i428;
import '../preference/impl/data_validity_pref_impl.dart' as _i509;
import '../wrapper/app_shared_pref.dart' as _i333;
import '../wrapper/impl/app_shared_pref_impl.dart' as _i994;
import 'pref_module.dart' as _i627;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initAppPref(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final prefModule = _$PrefModule();
  await gh.singletonAsync<_i460.SharedPreferences>(
    () => prefModule.sharedPref,
    preResolve: true,
  );
  gh.singleton<_i558.FlutterSecureStorage>(() => prefModule.secureStorage);
  gh.factory<_i333.AppSharedPref>(
    () => _i994.AppSharedPrefImpl(
      gh<_i460.SharedPreferences>(),
      gh<_i558.FlutterSecureStorage>(),
    ),
  );
  gh.lazySingleton<_i763.DataValidityPref>(
    () => _i509.DataValidityPrefImpl(gh<_i333.AppSharedPref>()),
  );
  gh.lazySingleton<_i821.AiApiKeyPref>(
    () => _i428.AiApiKeyPrefImpl(gh<_i333.AppSharedPref>()),
  );
  return getIt;
}

class _$PrefModule extends _i627.PrefModule {}
