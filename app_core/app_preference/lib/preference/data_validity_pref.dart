abstract class DataValidityPref {

  // Last update time methods
  Future<void> setLastUpdateTime(DateTime time);

  Future<DateTime?> getLastUpdateTime();

  // Data completeness methods
  Future<void> setDataComplete(bool complete);

  Future<bool> isDataComplete();

  // Check if data is older than 1 day
  Future<bool> isDataOlderThanOneDay();
}