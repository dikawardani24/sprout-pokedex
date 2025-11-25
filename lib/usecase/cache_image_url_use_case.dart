import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class CacheImageUrlUseCase {
  Future<void> execute(List<String> imageUrlList);
}

@Injectable(as: CacheImageUrlUseCase)
class CacheImageUrlUseCaseImpl implements CacheImageUrlUseCase {
  @override
  Future<void> execute(List<String> imageUrlList) async {
    await Future.wait(
      imageUrlList.map((p) async {
        final provider = CachedNetworkImageProvider(p);

        final imageStream = provider.resolve(const ImageConfiguration());
        final completer = Completer<void>();

        late final ImageStreamListener listener;
        listener = ImageStreamListener(
              (info, _) {
            completer.complete();
            imageStream.removeListener(listener);
          },
          onError: (err, stack) {
            completer.complete();
            imageStream.removeListener(listener);
          },
        );

        imageStream.addListener(listener);
        return completer.future;
      }),
    );
  }
}