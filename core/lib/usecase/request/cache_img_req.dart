import 'package:core/usecase/use_case.dart';

class CacheImgReq implements Request {
  final List<String> imageUrlList;

  const CacheImgReq({required this.imageUrlList});
}