import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum StorageKey {
  username,
  password,
  proxyUrl,
  serviceUrl,
}

class Storage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> get(StorageKey key) async {
    return await _storage.read(key: key.toString());
  }

  static Future<void> set(StorageKey key, String value) async {
    await _storage.write(key: key.toString(), value: value);
  }

  static Future<void> delete(StorageKey key) async {
    await _storage.delete(key: key.toString());
  }
}
