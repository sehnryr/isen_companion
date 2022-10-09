import 'dart:collection';

import 'package:isen_aurion_client/client.dart';
import 'package:isen_aurion_client/event.dart';
import 'package:isen_aurion_client/error.dart';

import 'package:isen_ouest_companion/storage.dart';

class Aurion {
  // The Aurion client
  static late IsenAurionClient _client;

  /// Get the default start date for the schedule.
  /// 2 weeks before the current week.
  static DateTime get defaultStart => _client.defaultStart;

  /// Get the default end date for the schedule.
  /// Last week of january.
  static DateTime get defaultEnd => _client.defaultEnd;

  /// Parse the schedule from [IsenAurionClient.getSchedule] and
  /// [IsenAurionClient.getUserSchedule] to a [LinkedHashMap]
  /// of [DateTime] to [List<Event>].
  static LinkedHashMap<DateTime, List<Event>> parseSchedule(
      List<Event> schedule) {
    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    int getHashCode(DateTime date) =>
        date.year * 10000 + date.month * 100 + date.day;

    LinkedHashMap<DateTime, List<Event>> events =
        LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
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

  /// Get the user schedule with all the options checked by default.
  ///
  /// Throws [ParameterNotFound] if Aurion's schedule is not in the
  /// expected format.
  static Future<LinkedHashMap<DateTime, List<Event>>> getUserSchedule() async {
    List<Event> schedule = await _client.getUserSchedule();

    return parseSchedule(schedule);
  }

  static Future<void> login(String username, String password) async {
    await Storage.set(StorageKey.username, username);
    await Storage.set(StorageKey.password, password);

    await _client.login(username, password);
  }

  static Future<void> init(String serviceUrl) async {
    await Storage.set(StorageKey.serviceUrl, serviceUrl);

    String? proxyUrl = await Storage.get(StorageKey.proxyUrl);
    _client = IsenAurionClient(serviceUrl: "$proxyUrl$serviceUrl");
  }
}
