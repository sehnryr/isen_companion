import 'dart:collection';

import 'package:isen_aurion_client/client.dart';
import 'package:isen_aurion_client/event.dart';

import 'package:isen_ouest_companion/storage.dart';

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

  static DateTime get defaultStart {
    return _client.defaultStart;
  }

  static DateTime get defaultEnd {
    return _client.defaultEnd;
  }

  static LinkedHashMap<DateTime, List<Event>> parseSchedule(
      List<Event> schedule) {
    LinkedHashMap<DateTime, List<Event>> events =
        LinkedHashMap<DateTime, List<Event>>(
      equals: (a, b) =>
          a.year == b.year && a.month == b.month && a.day == b.day,
      hashCode: (a) => a.year * 10000 + a.month * 100 + a.day,
    );

    for (Event event in schedule) {
      DateTime date = event.day;
      if (!events.containsKey(date)) {
        events[date] = [];
      }
      events[date]!.add(event);
    }

    return events;
  }

  static Future<LinkedHashMap<DateTime, List<Event>>> getUserSchedule() async {
    List<Event> schedule = await _client.getUserSchedule();

    return parseSchedule(schedule);
  }

  static Future<void> login(String username, String password) async {
    await init(_serviceUrl);

    await Storage.set(StorageKey.username, username);
    await Storage.set(StorageKey.password, password);

    await _client.login(username, password);
  }

  static Future<void> init(String serviceUrl) async {
    await Storage.set(StorageKey.serviceUrl, serviceUrl);

    String? proxyUrl = await Storage.get(StorageKey.proxyUrl);
    _serviceUrl = serviceUrl;
    _client = IsenAurionClient(serviceUrl: "$proxyUrl$serviceUrl");
  }
}
