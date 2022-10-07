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
    return prefs.containsKey(key.toString())
        ? await _storage.getString(key.toString())
        : null;
  }

  static Future<bool> set(StorageKey key, String value) async {
    return await _storage.setString(key.toString(), value);
  }

  static Future<bool> delete(StorageKey key) async {
    return await _storage.remove(key.toString());
  }
}
