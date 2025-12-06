import 'package:core/usecase/use_case.dart';

class GetChatHistoriesReq extends Request {
  final int offset;

  GetChatHistoriesReq({required this.offset});
}