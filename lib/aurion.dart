import 'dart:collection';

import 'package:isen_aurion_client/client.dart';
import 'package:isen_aurion_client/event.dart';
import 'package:isen_aurion_client/error.dart';

import 'package:isen_ouest_companion/storage.dart';

class Aurion {
  static late String _serviceUrl;

  static late IsenAurionClient _client;

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

  /// Get the schedule with all the options checked by default.
  ///
  /// Throws [ParameterNotFound] if Aurion's schedule is not in the
  /// expected format.
  static Future<LinkedHashMap<DateTime, List<Event>>> getSchedule({
    required String groupId,
  }) async {
    List<Event> schedule = await _client.getSchedule(groupId: groupId);

    return parseSchedule(schedule);
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
