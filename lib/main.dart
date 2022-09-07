import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progress_hud/progress_hud_wrapper.dart';
import 'package:route_creator/route_creator.dart';

void main() async {
  // Enable Flutter cryptography
  FlutterCryptography.enable();

  // Initialize Hive for flutter
  await Hive.initFlutter();
  await Hive.openBox('isenOuestCompanionBox');

  await initializeDateFormatting();

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
          return const ProgressHUDWrapper(child: MyHomePage(title: 'Demo v3'));
        }),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var box = Hive.box('isenOuestCompanionBox');
  String counterKey = 'counter';

  @override
  void initState() {
    if (!box.containsKey(counterKey)) {
      box.put(counterKey, 0);
    }

    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      box.put(counterKey, box.get(counterKey) + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              box.get('counter').toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
