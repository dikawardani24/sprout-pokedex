import 'package:core/core.dart';
import 'package:core/usecase/use_case.dart';

class DeleteHistoryReq extends Request{
  final ChatHistory chatHistory;

  DeleteHistoryReq(this.chatHistory);
}