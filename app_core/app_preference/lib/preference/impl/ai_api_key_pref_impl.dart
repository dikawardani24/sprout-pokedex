import 'package:app_preference/preference/ai_api_key_pref.dart';
import 'package:injectable/injectable.dart';

import '../../wrapper/app_shared_pref.dart';

@Injectable(as: AiApiKeyPref)
class AiApiKeyPrefImpl implements AiApiKeyPref {
  final _keyApiKey = "API_KEY";
  final AppSharedPref _sharedPref;

  const AiApiKeyPrefImpl(this._sharedPref);

  @override
  Future<String> getApiKey() async =>
      await _sharedPref.getStringOrDefault(_keyApiKey, "");

  @override
  Future<bool> isApiKeySet() async => (await getApiKey()).isNotEmpty;

  @override
  Future<void> save(String apiKey) async =>
      await _sharedPref.setString(_keyApiKey, apiKey);

}