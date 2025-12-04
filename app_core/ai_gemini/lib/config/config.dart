

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AiConfig {
  final String apiKey;
  final bool isDebug;
  final String model;
  final double temp;
  final double topP;
  final int topK;
  final int maxOutput;

  AiConfig({
    required this.apiKey,
    required this.isDebug,
    this.model = "gemini-2.5-flash",
    this.temp = 0.7,
    this.topK = 40,
    this.topP = 0.9,
    this.maxOutput = 4096,
  });

  static Future<AiConfig> create() async {
    String apiKey = "";
    if (kDebugMode) {
      final jsonString = await rootBundle.loadString("assets/env.json");
      Map<String, dynamic> json = jsonDecode(jsonString);
      apiKey = json["api_key"] as String;
    }

    if (apiKey.isEmpty) throw Exception("Api key invalid");
    return AiConfig(apiKey: apiKey, isDebug: kDebugMode);
  }
}
