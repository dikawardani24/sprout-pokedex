import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';

import '../log_interceptor.dart';

@module
abstract class ApiModule {
  PokeAPIClient? _client() {
    return null;
    if (kDebugMode) {
      final httpClient = InterceptedClient.build(
        interceptors: [LoggingInterceptor()],
      );
      return PokeAPIClient(client: httpClient);
    }
    return null;
  }

  @singleton
  Pokedex get pokedex => Pokedex(client: _client());
}