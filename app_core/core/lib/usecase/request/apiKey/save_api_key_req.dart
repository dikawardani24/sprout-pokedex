import 'package:core/usecase/use_case.dart';

class SaveApiKeyReq extends Request {
  final String apiKey;

  SaveApiKeyReq(this.apiKey);
}