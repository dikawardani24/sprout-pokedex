import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../service/network_service.dart';

abstract class ValidateConnectionUseCase {
  Future<void> execute();
}

@Injectable(as: ValidateConnectionUseCase)
class ValidateConnectionUseCaseImpl implements ValidateConnectionUseCase {
  final NetworkService _networkService;

  const ValidateConnectionUseCaseImpl(this._networkService);

  @override
  Future<void> execute() async {
    if (AppConfig.isWeb || AppConfig.isDesktop) return;
    final isConnected = await _networkService.isConnected();
    if (!isConnected) throw Exception("No internet connection");
  }
}