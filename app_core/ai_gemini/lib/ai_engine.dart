import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'config/config.dart';

class AiEngine {
  bool _initiated = false;

  Future<AiConfig> _init() async {
    String apiKey = "";
    if (kDebugMode) {
      final jsonString = await rootBundle.loadString("assets/env.json");
      Map<String, dynamic> json = jsonDecode(jsonString);
      apiKey = json["api_key"] as String;
    }

    if (apiKey.isEmpty) throw Exception("Api key invalid");
    return AiConfig(apiKey: apiKey, isDebug: kDebugMode);
  }

  Future<Gemini> get gemini async {
    final config  = await _init();
    if (!_initiated) {
      Gemini.init(
        apiKey: config.apiKey,
        enableDebugging: kDebugMode,
        // version: config.model
      );
      _initiated = true;
    }
    return Gemini.instance;
  }
}