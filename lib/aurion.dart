import 'dart:collection';

import 'package:isen_aurion_client/isen_aurion_client.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:isen_ouest_companion/storage.dart';

/// Possible event types
enum EventType {
  course,
  exam,
  leave,
  meeting,
  practicalWork,
  supervisedWork,
  undefined,
}

/// Schedule event class.
class Event {
  final int id;
  final EventType type;
  final DateTime start;
  final DateTime end;
  final String room;
  final String subject;
  final String chapter;
  final List<String> participants;

  const Event({
    required this.id,
    required this.type,
    required this.start,
    required this.end,
    required this.room,
    required this.subject,
    required this.chapter,
    required this.participants,
  });

  @override
  String toString() => subject;

  DateTime get day => DateTime(
        start.year,
        start.month,
        start.day,
      );

  /// Gets the [EventType] of a [String].
  static EventType mapType(String rawType) {
    switch (rawType) {
      case "CONGES":
        return EventType.leave;
      case "COURS":
        return EventType.course;
      case "est-epreuve":
      case "EVALUATION":
        return EventType.exam;
      case "REUNION":
        return EventType.meeting;
      case "TD":
        return EventType.supervisedWork;
      case "TP":
        return EventType.practicalWork;
      default:
        return EventType.undefined;
    }
  }
}

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

  static Future<LinkedHashMap<DateTime, List<Event>>> getUserSchedule(
      {DateTime? start, DateTime? end}) async {
    List<Map<String, dynamic>> schedule = await _client.getUserSchedule(
      start: start,
      end: end,
    );

    LinkedHashMap<DateTime, List<Event>> events =
        LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    for (var element in schedule) {
      Event event = Event(
        id: element['id'],
        type: Event.mapType(element['type']),
        start: DateTime.fromMillisecondsSinceEpoch(element['start']),
        end: DateTime.fromMillisecondsSinceEpoch(element['end']),
        room: element['room'],
        subject: element['subject'],
        chapter: element['chapter'],
        participants: element['participants'],
      );
      DateTime day = event.day;

      if (events.containsKey(day)) {
        events[day]!.add(event);
      } else {
        events.addAll({
          day: [event]
        });
      }
    }

    return events;
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

int getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;
