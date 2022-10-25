import 'package:flutter/foundation.dart';

import 'package:universal_html/html.dart' show window;

class Platform {
  static final _userAgent = window.navigator.userAgent;

  static bool _contains(Pattern value) => _userAgent.contains(value);

  static bool get isWeb => kIsWeb;

  static bool get _chrome => _contains(RegExp(r'C(hrome|riOS)\/'));
  static bool get _egde => _contains(RegExp(r'Edg(e|A|iOS)?\/'));
  static bool get _firefox => _contains(RegExp(r'F(irefox|xiOS)/'));
  static bool get _ie => _contains('Trident/');
  static bool get _opera => _contains('OPR/');
  static bool get _safari =>
      _contains('Safari/') &&
      !(_chrome || _egde || _firefox || _opera || _vivaldi || _yandex);
  static bool get _vivaldi => _contains('Vivaldi/');
  static bool get _yandex => _contains('YaBrowser/');

  // https://www.whatismybrowser.com/guides/the-latest-user-agent/
  static bool get isChrome => isWeb && _chrome;
  static bool get isEdge => isWeb && _egde;
  static bool get isFirefox => isWeb && _firefox;
  static bool get isIE => isWeb && _ie;
  static bool get isOpera => isWeb && _opera;
  static bool get isSafari => isWeb && _safari;
  static bool get isVivaldi => isWeb && _vivaldi;
  static bool get isYandex => isWeb && _yandex;
}
