import 'package:database/db_platform.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

@injectable
class DbInit {
  static DbPlatform dbPlatform = DbInit.dbPlatform;
  static bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (dbPlatform == DbPlatform.desktop) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _isInitialized = true;
  }

  static bool get isInitialized => _isInitialized;
}