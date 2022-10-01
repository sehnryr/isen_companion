import 'package:isen_aurion_client/isen_aurion_client.dart';

import 'package:isen_ouest_companion/secure_storage.dart';

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

  static Future<List<Map<String, dynamic>>> getUserSchedule(
      {DateTime? start, DateTime? end}) {
    return _client.getUserSchedule(
      start: start,
      end: end,
    );
  }

  static Future<void> login(String username, String password) async {
    await init(_serviceUrl);

    await SecureStorage.set(SecureStorageKey.username, username);
    await SecureStorage.set(SecureStorageKey.password, password);

    await _client.login(username, password);
  }

  static Future<void> init(String serviceUrl) async {
    await SecureStorage.set(SecureStorageKey.serviceUrl, serviceUrl);

    String? proxyUrl = await SecureStorage.get(SecureStorageKey.proxyUrl);
    _serviceUrl = serviceUrl;
    _client = IsenAurionClient(serviceUrl: "$proxyUrl$serviceUrl");
  }
}
