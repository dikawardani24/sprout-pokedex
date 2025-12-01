import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkService {
  Future<ConnectivityResult?> activeConnection();
  Future<bool> isConnected();
}