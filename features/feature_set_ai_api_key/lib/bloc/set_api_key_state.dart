import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_api_key_state.freezed.dart';

@freezed
class SetApiKeyState with _$SetApiKeyState {
  const factory SetApiKeyState.initial() = _Initial;
  const factory SetApiKeyState.loadingSaveApiKey() = _LoadingSaveApiKey;
  const factory SetApiKeyState.apiKeySaved() = _ApiKeySaved;
  const factory SetApiKeyState.errSaveApiKey(String message) = _ErrSaveApiKey;
}