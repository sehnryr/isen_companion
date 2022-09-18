import 'package:flutter/foundation.dart';

class DefaultSettings {
  const DefaultSettings();

  static String get proxyUrl =>
      kIsWeb ? "https://restless-forest-4699.fly.dev/?url=" : "";
  static String get serviceUrl => "https://web.isen-ouest.fr/webAurion/";
}
