import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import 'package:custom_go_route/slide_or_go_route.dart';
import 'package:universal_html/html.dart' show window;
import 'package:url_strategy/url_strategy.dart';

import 'package:isen_companion/base/status_bar_color.dart';
import 'package:isen_companion/config.dart';
import 'package:isen_companion/login/login_page.dart';
import 'package:isen_companion/recover_password/recover_password_page.dart';
import 'package:isen_companion/schedule/schedule_page.dart';
import 'package:isen_companion/settings/settings_page.dart';
import 'package:isen_companion/storage.dart';

void main() async {
  await initializeDateFormatting();

  SystemChrome.setSystemUIOverlayStyle(const StatusBarColor());

  WidgetsFlutterBinding.ensureInitialized();

  // Proxy initialization
  String? proxyUrl = await Storage.get(StorageKey.proxyUrl);
  proxyUrl = proxyUrl ?? (kIsWeb ? Config.proxyUrl : "");
  await Storage.set(StorageKey.proxyUrl, proxyUrl);

  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: router,
        title: 'ISEN Ouest Companion',
        locale: const Locale('fr', 'FR'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF6E6E6E),
            onPrimary: Colors.white,
            primaryContainer: const Color(0xFF4F4F4F),
          ),
          textTheme: const TextTheme(
            headline1: TextStyle(
              color: Color(0xFF6E6E6E),
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
      );

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          return '/login';
        },
      ),
      SlideOrGoRoute(
        path: '/login',
        target: const LoginPage(),
        direction: Direction.fromLeft,
      ),
      SlideOrGoRoute(
        path: '/schedule',
        target: const SchedulePage(),
        direction: Direction.fromRight,
        redirect: (context, state) async {
          if (await Storage.get(StorageKey.password) == null) {
            return '/login';
          }
          return null;
        },
      ),
      SlideOrGoRoute(
        path: '/settings',
        target: const SettingsPage(),
        direction: Direction.fromRight,
      ),
      SlideOrGoRoute(
        path: '/recover',
        target: const RecoverPasswordPage(),
        direction: Direction.fromBottom,
      ),
    ],
    initialLocation: '/login',
  );
}
