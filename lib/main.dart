import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:universal_html/html.dart' show window;

import 'package:isen_ouest_companion/aurion.dart';
import 'package:isen_ouest_companion/base/status_bar_color.dart';
import 'package:isen_ouest_companion/config.dart';
import 'package:isen_ouest_companion/login/login_page.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_page.dart';
import 'package:isen_ouest_companion/schedule/schedule_page.dart';
import 'package:isen_ouest_companion/settings/settings_page.dart';
import 'package:isen_ouest_companion/storage.dart';

void main() async {
  await initializeDateFormatting();

  SystemChrome.setSystemUIOverlayStyle(const StatusBarColor());

  runApp(const MyApp());

  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    () async {
      String? proxyUrl = await Storage.get(StorageKey.proxyUrl);
      proxyUrl = proxyUrl ?? (kIsWeb ? Config.proxyUrl : "");
      await Storage.set(StorageKey.proxyUrl, proxyUrl);

      String? serviceUrl = await Storage.get(StorageKey.serviceUrl);
      serviceUrl = serviceUrl ?? Config.serviceUrl;
      await Aurion.init(serviceUrl);
    }.call();
    super.initState();
  }

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
      child: MaterialApp.router(
        routerConfig: router,
        title: 'ISEN Ouest Companion',
        locale: const Locale('fr', 'FR'),
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
      ),
    );
  }

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          return '/login';
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const ProgressHUD(child: LoginPage()),
      ),
      GoRoute(
        path: '/schedule',
        builder: (context, state) => const ProgressHUD(child: SchedulePage()),
        redirect: (context, state) async {
          if (await Storage.get(StorageKey.password) != null) {
            return state.location;
          }
          return '/login';
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const ProgressHUD(child: SettingsPage()),
      ),
      GoRoute(
        path: '/recover',
        builder: (context, state) =>
            const ProgressHUD(child: RecoverPasswordPage()),
      ),
    ],
    initialLocation: '/login',
  );
}
