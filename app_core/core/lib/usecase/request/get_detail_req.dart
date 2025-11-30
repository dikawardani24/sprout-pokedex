import 'package:core/usecase/use_case.dart';

class GetDetailReq implements Request {
  final int id;

  const GetDetailReq({required this.id});
}