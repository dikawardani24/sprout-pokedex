import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import '../network_service.dart';

@Injectable(as: NetworkService)
class NetworkServiceImpl implements NetworkService {
  final Connectivity connectivity;

  NetworkServiceImpl({Connectivity? connectivity})
      : connectivity = connectivity ?? Connectivity();

  @override
  Future<ConnectivityResult?> activeConnection() async {
    final result = await connectivity.checkConnectivity();
    return result.firstWhereOrNull((e) => e != ConnectivityResult.none);
  }

  @override
  Future<bool> isConnected() async => await activeConnection() != null;
}
