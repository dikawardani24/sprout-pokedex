abstract class AppSharedPref {
  Future<void> setInt(String key, int value);
  Future<void> setTime(String key, DateTime time);
  Future<void> setBool(String key, bool value);
  Future<void> setString(String key, String value, {bool isSecure = false});
  Future<void> setDouble(String key, double value);

  Future<int?> getInt(String key);
  Future<DateTime?> getTime(String key);
  Future<bool?> getBool(String key);
  Future<String?> getString(String key, {bool isSecure = false});
  Future<double?> getDouble(String key);

  Future<int> getIntOrDefault(String key, int defaultValue);
  Future<DateTime?> getTimeOrDefault(String key, DateTime defaultValue);
  Future<bool> getBoolOrDefault(String key, bool defaultValue);
  Future<String> getStringOrDefault(String key, String defaultValue, {bool isSecure = false});
  Future<double> getDoubleOrDefault(String key, double defaultValue);
}