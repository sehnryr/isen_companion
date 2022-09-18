import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:route_creator/route_creator.dart';
import 'package:flutter/services.dart';
import 'package:secure_storage/secure_storage.dart';

import 'package:isen_ouest_companion/login/login_page.dart';
import 'package:isen_ouest_companion/base/status_bar_color.dart';
import 'package:isen_ouest_companion/settings/settings_page.dart';

void main() async {
  // Enable Flutter cryptography
  FlutterCryptography.enable();

  await initializeDateFormatting();

  SystemChrome.setSystemUIOverlayStyle(const StatusBarColor());

  SecureStorage.set(SecureStorageKey.CORSProxy, DefaultSettings.defaultProxy);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF6D6875),
            onPrimary: Colors.white,
            primaryContainer: const Color(0xFF4D4955),
          ),
          textTheme: const TextTheme(
            headline1: TextStyle(
              color: Color(0xFF6D6875),
              letterSpacing: -1.5,
              fontSize: 34,
              fontWeight: FontWeight.w500,
            ),
            button: TextStyle(
              color: Colors.white,
              letterSpacing: 1.25,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overline: TextStyle(
              letterSpacing: 1.5,
              fontSize: 10,
              fontWeight: FontWeight.normal,
            ),
          ),

          // https://github.com/flutter/flutter/issues/93140
          fontFamily: kIsWeb && window.navigator.userAgent.contains('OS 15_')
              ? '-apple-system'
              : null,
        ),
        home: Builder(builder: (context) {
          return const ProgressHUD(child: LoginPage());
        }),
      ),
    );
  }
}
