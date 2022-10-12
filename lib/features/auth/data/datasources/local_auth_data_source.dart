import 'package:instagram_clone/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorageKeys {
  UID,
  TOKEN,
}

abstract class LocalAuthDataSource {

  Future<bool> storeData(StorageKeys key, String data);

  String loadData(StorageKeys key);

  Future<bool> removeData(StorageKeys key);
}

class LocalAuthDataSourceIml extends LocalAuthDataSource {
  final SharedPreferences local;

  LocalAuthDataSourceIml({required this.local});

  @override
  String loadData(StorageKeys key) {
    String? data = local.getString(_getKey(key));
    if(data != null) {
      return data;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> removeData(StorageKeys key) async {
    return await local.remove(_getKey(key));
  }

  @override
  Future<bool> storeData(StorageKeys key, String data) async {
    return await local.setString(_getKey(key), data);
  }

  String _getKey(StorageKeys key) {
    switch(key) {
      case StorageKeys.UID: return "uid";
      case StorageKeys.TOKEN: return "token";
    }
  }
}
