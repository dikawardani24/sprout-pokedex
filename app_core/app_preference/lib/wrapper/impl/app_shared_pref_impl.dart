import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_shared_pref.dart';

@Injectable(as: AppSharedPref)
class AppSharedPrefImpl implements AppSharedPref{

  Future<SharedPreferences> get _sharedPref async => await SharedPreferences.getInstance();

  Future<T> _getOrDefault<T>(
      String key,
      T defaultValue,
      Future<T?> Function(String) getter) async {
    final value = await getter(key);
    if (value != null) return value;
    return defaultValue;
  }

  @override
  Future<bool?> getBool(String key) async => (await _sharedPref).getBool(key);

  @override
  Future<int?> getInt(String key) async => (await _sharedPref).getInt(key);

  @override
  Future<String?> getString(String key) async => (await _sharedPref).getString(key);

  @override
  Future<DateTime?> getTime(String key) async {
    final milliSeconds = await getInt(key);
    if (milliSeconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliSeconds);
  }

  @override
  Future<double?> getDouble(String key) async => (await _sharedPref).getDouble(key);

  @override
  Future<void> setBool(String key, bool value) async => (await _sharedPref).setBool(key, value);

  @override
  Future<void> setInt(String key, int value) async => (await _sharedPref).setInt(key, value);

  @override
  Future<void> setString(String key, String value) async => (await _sharedPref).setString(key, value);

  @override
  Future<void> setTime(String key, DateTime time) async => await setInt(key, time.millisecondsSinceEpoch);

  @override
  Future<void> setDouble(String key, double value) async => (await _sharedPref).setDouble(key, value);

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
  Future<String> getStringOrDefault(String key, String defaultValue) async => _getOrDefault(
    key,
    defaultValue,
    getString
  );

  @override
  Future<DateTime?> getTimeOrDefault(String key, DateTime defaultValue) async => _getOrDefault(
    key,
    defaultValue,
    getTime
  );

}