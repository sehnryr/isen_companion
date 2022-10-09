import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

enum StorageKey {
  username,
  password,
  proxyUrl,
  serviceUrl,
}

class Storage {
  static final EncryptedSharedPreferences _storage =
      EncryptedSharedPreferences();

  static Future<String?> get(StorageKey key) async {
    var prefs = await _storage.getInstance();
    if (prefs.containsKey(key.toString())) {
      String value = prefs.getString(key.toString())!;
      if (value.isEmpty) {
        return value;
      } else {
        return _storage.getString(key.toString());
      }
    }
    return null;
  }

  static Future<bool> set(StorageKey key, String value) async {
    var prefs = await _storage.getInstance();
    if (value.isEmpty) {
      bool returnValue = await prefs.setString(key.toString(), value);
      _storage.prefs = prefs;
      return returnValue;
    }
    return await _storage.setString(key.toString(), value);
  }

  static Future<bool> delete(StorageKey key) async {
    return await _storage.remove(key.toString());
  }
}
