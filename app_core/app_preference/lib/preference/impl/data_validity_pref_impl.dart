import 'package:injectable/injectable.dart';

import '../../wrapper/app_shared_pref.dart';
import '../data_validity_pref.dart';

@LazySingleton(as: DataValidityPref)
class DataValidityPrefImpl implements DataValidityPref {
  final _lastUpdateKey = 'last_pokemon_update';
  final String _dataCompleteKey = 'pokemon_data_complete';
  final AppSharedPref _sharedPref;

  const DataValidityPrefImpl(this._sharedPref);

  @override
  Future<void> setLastUpdateTime(DateTime time) async => await _sharedPref
      .setInt(_lastUpdateKey, time.millisecondsSinceEpoch);

  @override
  Future<DateTime?> getLastUpdateTime() async {
    final timestamp = await _sharedPref.getInt(_lastUpdateKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  Future<void> setDataComplete(bool complete) async => await _sharedPref
      .setBool(_dataCompleteKey, complete);

  @override
  Future<bool> isDataComplete() async => await _sharedPref.getBoolOrDefault(_dataCompleteKey, false);

  @override
  Future<bool> isDataOlderThanOneDay() async {
    final lastUpdate = await getLastUpdateTime();
    if (lastUpdate == null) return true; // No data yet

    final now = DateTime.now();
    final difference = now.difference(lastUpdate);
    return difference.inHours > 24;
  }
}