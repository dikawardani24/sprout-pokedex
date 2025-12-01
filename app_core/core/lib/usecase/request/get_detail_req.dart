import 'package:core/usecase/use_case.dart';

class GetDetailReq implements Request {
  final int id;
  final bool forceFromRemote;

  const GetDetailReq({
    required this.id,
    this.forceFromRemote = false
  });
}