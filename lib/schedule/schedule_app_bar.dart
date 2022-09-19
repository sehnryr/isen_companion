import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:route_creator/route_creator.dart';

import 'package:isen_ouest_companion/base/status_bar_color.dart';
import 'package:isen_ouest_companion/login/login_page.dart';
import 'package:isen_ouest_companion/secure_storage.dart';

class ScheduleAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function() showCalendarState;
  final AnimationController animationController;
  final DateTime focusedDay;
  final String locale;

  const ScheduleAppBar({
    Key? key,
    required this.showCalendarState,
    required this.animationController,
    required this.focusedDay,
    required this.locale,
  }) : super(key: key);

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
      title: InkWell(
        onTap: widget.showCalendarState,
        child: Container(
          padding: const EdgeInsets.only(left: 5),
          height: widget.preferredSize.height,
          child: Row(children: [
            Text(toBeginningOfSentenceCase(
                    DateFormat.MMMM(widget.locale).format(widget.focusedDay)) ??
                "Erreur"),
            RotationTransition(
              turns: Tween(begin: 0.0, end: -0.5)
                  .chain(CurveTween(curve: Curves.easeInOut))
                  .animate(widget.animationController),
              child: const Icon(Icons.arrow_drop_down),
            ),
          ]),
        ),
      ),
    );
  }
}
