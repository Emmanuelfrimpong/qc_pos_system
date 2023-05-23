import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;

class DBConnection {
  static DBConnection? _instance;

  final String _host = "127.0.0.1";
  final String _port = "27017";
  final String _dbName = "quickchange";
  Db? _db;

  static getInstance() {
    _instance ??= DBConnection();
    return _instance;
  }

  Future<Db> getConnection() async {
    if (_db == null) {
      try {
        _db = Db(_getConnectionString());
        await _db!.open();
      } catch (e) {
        print(e);
      }
    }
    return _db!;
  }

  _getConnectionString() {
    return "mongodb://$_host:$_port/$_dbName";
  }

  closeConnection() {
    _db!.close();
  }
}
