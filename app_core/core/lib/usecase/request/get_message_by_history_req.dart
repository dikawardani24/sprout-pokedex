import 'package:core/core.dart';
import 'package:core/usecase/use_case.dart';

class GetMessageByHistoryReq extends Request {
  final ChatHistory chatHistory;

  GetMessageByHistoryReq(this.chatHistory);
}