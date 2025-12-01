import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/usecase/request/cache_img_req.dart';
import 'package:core/usecase/use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class CacheImageUrlUseCase extends UseCase<CacheImgReq, void> {}

@Injectable(as: CacheImageUrlUseCase)
class CacheImageUrlUseCaseImpl implements CacheImageUrlUseCase {

  @override
  Future<Result<void>> execute(CacheImgReq req) async {
    try {
      await Future.wait(
        req.imageUrlList.map((url) => _precacheImage(url)),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.error('Failed to cache images: $e');
    }
  }

  Future<void> _precacheImage(String imageUrl) async {
    final provider = CachedNetworkImageProvider(imageUrl);
    final imageStream = provider.resolve(const ImageConfiguration());

    final completer = Completer<void>();

    late final ImageStreamListener listener;
    listener = ImageStreamListener(
          (imageInfo, synchronousCall) {
        completer.complete();
        imageStream.removeListener(listener);
      },
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace);
        imageStream.removeListener(listener);
      },
    );

    imageStream.addListener(listener);
    return completer.future;
  }
}