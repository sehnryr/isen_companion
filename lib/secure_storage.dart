import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageKey {
  final _value;
  const SecureStorageKey._internal(this._value);
  @override
  toString() => "SecureStorageKey.$_value";

  static const Username = SecureStorageKey._internal("username");
  static const Password = SecureStorageKey._internal("password");
  static const CORSProxy = SecureStorageKey._internal("cors_proxy");
  static const ServiceUrl = SecureStorageKey._internal("service_url");
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
