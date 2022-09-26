import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKey {
  username,
  password,
  proxyUrl,
  serviceUrl,
}

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> get(SecureStorageKey key) async {
    return await _storage.read(key: key.toString());
  }

  static Future<void> set(SecureStorageKey key, String value) async {
    await _storage.write(key: key.toString(), value: value);
  }

  static Future<void> delete(SecureStorageKey key) async {
    await _storage.delete(key: key.toString());
  }
}
