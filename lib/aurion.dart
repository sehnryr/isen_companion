import 'package:isen_aurion_client/isen_aurion_client.dart';

import 'package:isen_ouest_companion/secure_storage.dart';

class Aurion {
  static late String _serviceUrl;

  static late IsenAurionClient _client;

  // static Future<List<Map<String, dynamic>>> getSchedule(
  //     {required String groupId,
  //     List<Map>? path,
  //     List<Map>? options,
  //     DateTime? start,
  //     DateTime? end}) {
  //   return client.getSchedule(
  //     groupId: groupId,
  //     path: path,
  //     options: options,
  //     start: start,
  //     end: end,
  //   );
  // }

  static Future<List<Map<String, dynamic>>> getUserSchedule(
      {DateTime? start, DateTime? end}) {
    return _client.getUserSchedule(
      start: start,
      end: end,
    );
  }

  static Future<void> login(String username, String password) async {
    await init(_serviceUrl);

    await SecureStorage.set(SecureStorageKey.Username, username);
    await SecureStorage.set(SecureStorageKey.Password, password);

    return _client.login(username, password);
  }

  static Future<void> init(String serviceUrl) async {
    await SecureStorage.set(SecureStorageKey.ServiceUrl, serviceUrl);

    _serviceUrl = serviceUrl;
    _client = IsenAurionClient(serviceUrl: _serviceUrl);
  }
}
