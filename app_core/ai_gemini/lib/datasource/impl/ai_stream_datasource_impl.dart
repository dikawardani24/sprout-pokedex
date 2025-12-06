import 'package:injectable/injectable.dart';

import '../../ai_engine.dart';
import '../ai_stream_datasource.dart';

@Injectable(as: AiStreamDatasource)
class AiStreamDatasourceImpl implements AiStreamDatasource {
  final AiEngine _aiEngine;
  AiStreamDatasourceImpl(this._aiEngine);

  @override
  Future<Stream<String?>> promptText({
    required String prompt,
    List<String> history = const [],
  }) async => await _aiEngine.streamChat(prompt, history: history);

  @override
  Future<Stream<String?>> promptTextWithTopic({
    required String prompt,
    List<String> history = const [],
    required String topic
  }) async => await _aiEngine.streamChat(prompt, history: history, topic: topic);
}