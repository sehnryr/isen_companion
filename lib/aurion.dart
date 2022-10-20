import 'dart:collection';

import 'package:isen_aurion_client/client.dart';
import 'package:isen_aurion_client/event.dart';
import 'package:isen_aurion_client/error.dart';

import 'package:isen_companion/storage.dart';

enum Campus {
  brest,
  caen,
  lille,
  nantes,
  rennes,
}

class Aurion {
  // The Aurion client
  static late AurionClient _client;

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
  static Future<LinkedHashMap<DateTime, List<Event>>> getGroupSchedule({
    required String groupId,
  }) async {
    List<Event> schedule = await _client.getGroupSchedule(groupId: groupId);

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
    await init();

    await Storage.set(StorageKey.username, username);
    await Storage.set(StorageKey.password, password);

    _client = IsenAurionClient(serviceUrl: _client.serviceUrl);

    await _client.login(username, password);
  }

  static Future<void> init() async {
    _client = await _getClient(Campus.nantes);
  }

  /// Get the Aurion client for the given [campus].
  ///
  /// TODO: Make the campus configurable.
  static Future<AurionClient> _getClient(Campus campus) async {
    int languageCode;
    String schoolingId;
    String userPlanningId;
    String groupsPlanningsId;
    String serviceUrl;

    String? proxyUrl = await Storage.get(StorageKey.proxyUrl);

    switch (campus) {
      case Campus.brest:
      case Campus.caen:
      case Campus.nantes:
      case Campus.rennes:
        languageCode = 275805;
        schoolingId = 'submenu_291906';
        userPlanningId = '1_3';
        groupsPlanningsId = 'submenu_299102';
        serviceUrl = '${proxyUrl}https://web.isen-ouest.fr/webAurion/';
        break;
      case Campus.lille:
        languageCode = 44323;
        schoolingId = 'submenu_44413';
        userPlanningId = '3_3';
        groupsPlanningsId = 'submenu_3131476';
        serviceUrl = '${proxyUrl}https://aurion.junia.com/';
        break;
    }

    return AurionClient(
      languageCode: languageCode,
      schoolingId: schoolingId,
      userPlanningId: userPlanningId,
      groupsPlanningsId: groupsPlanningsId,
      serviceUrl: serviceUrl,
    );
  }
}
