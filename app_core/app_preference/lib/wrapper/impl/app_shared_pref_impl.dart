import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_shared_pref.dart';

@Injectable(as: AppSharedPref)
class AppSharedPrefImpl implements AppSharedPref{

  final SharedPreferences _sharedPref;
  final FlutterSecureStorage _secureStorage;

  AppSharedPrefImpl(this._sharedPref, this._secureStorage);

  Future<T> _getOrDefault<T>(
      String key,
      T defaultValue,
      Future<T?> Function(String) getter) async {
    final value = await getter(key);
    if (value != null) return value;
    return defaultValue;
  }

  @override
  Future<bool?> getBool(String key) async => _sharedPref.getBool(key);

  @override
  Future<int?> getInt(String key) async => _sharedPref.getInt(key);

  @override
  Future<String?> getString(String key, {bool isSecure = false}) async {
    if (!isSecure) return _sharedPref.getString(key);
    return _secureStorage.read(key: key);
  }

  @override
  Future<DateTime?> getTime(String key) async {
    final milliSeconds = await getInt(key);
    if (milliSeconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliSeconds);
  }

  @override
  Future<double?> getDouble(String key) async => _sharedPref.getDouble(key);

  @override
  Future<void> setBool(String key, bool value) async => _sharedPref.setBool(key, value);

  @override
  Future<void> setInt(String key, int value) async => _sharedPref.setInt(key, value);

  @override
  Future<void> setString(String key, String value, {bool isSecure = false}) async {
    if (!isSecure) _sharedPref.setString(key, value);
    _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> setTime(String key, DateTime time) async => await setInt(key, time.millisecondsSinceEpoch);

  @override
  Future<void> setDouble(String key, double value) async => _sharedPref.setDouble(key, value);

  @override
  Future<bool> getBoolOrDefault(String key, bool defaultValue) async => await _getOrDefault(
    key,
    defaultValue,
    getBool
  );

  @override
  Future<double> getDoubleOrDefault(String key, double defaultValue) async => _getOrDefault(
    key,
    defaultValue,
    getDouble
  );

  @override
  Future<int> getIntOrDefault(String key, int defaultValue) async => _getOrDefault(
    key,
    defaultValue,
    getInt
  );

  @override
  Future<String> getStringOrDefault(String key, String defaultValue, {bool isSecure = false}) async => _getOrDefault(
    key,
    defaultValue,
    isSecure ? (key) => getString(key, isSecure: isSecure) : getString
  );

  @override
  Future<DateTime?> getTimeOrDefault(String key, DateTime defaultValue) async => _getOrDefault(
    key,
    defaultValue,
    getTime
  );

}