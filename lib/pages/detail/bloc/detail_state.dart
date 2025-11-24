
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sprout_pokedex/models/about_info.dart';

part 'detail_state.freezed.dart';

@freezed
class DetailState with _$DetailState{
  const factory DetailState.initial() = _Initial;
  const factory DetailState.loading() = _Loading;
  const factory DetailState.loaded(AboutInfo info) = _Loaded;
  const factory DetailState.error(String message) = _Error;
}