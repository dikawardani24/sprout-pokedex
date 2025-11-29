
import 'package:freezed_annotation/freezed_annotation.dart';

part 'use_case.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = _Success;
  const factory Result.error(dynamic err) = _Error;
}

abstract class Request {}

abstract class UseCase <Req extends Request, OutPut>{
  Future<Result<OutPut>> execute(Req req);
}