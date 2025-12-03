import 'package:core/usecase/use_case.dart';

class GreetReq extends Request {
  final String? topic;
  GreetReq(this.topic);
}