import 'package:flutter/material.dart';
import 'package:isen_ouest_companion/secure_storage.dart';

import 'package:route_creator/route_creator.dart';

import 'package:isen_ouest_companion/base/status_bar_color.dart';
import 'package:isen_ouest_companion/login/login_page.dart';

class ScheduleAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ScheduleAppBar({Key? key}) : super(key: key);

  @override
  ScheduleAppBarState createState() => ScheduleAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class ScheduleAppBarState extends State<ScheduleAppBar> {
  void disconnect() {
    SecureStorage.delete(SecureStorageKey.Password)
        .then((_) => Navigator.of(context).pushReplacement(createRoute(
              const LoginPage(),
              Direction.fromLeft,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const StatusBarColor(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(
          onPressed: disconnect,
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
