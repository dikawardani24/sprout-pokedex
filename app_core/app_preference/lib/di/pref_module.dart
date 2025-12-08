import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class PrefModule {

  @singleton
  Future<SharedPreferences> get sharedPref async => await SharedPreferences.getInstance();

  @singleton
  FlutterSecureStorage get secureStorage => FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
      synchronizable: false
    ),
    webOptions: WebOptions(
      dbName: "pokedex_secure_db"
    ),
  );

}