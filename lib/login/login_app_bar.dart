import 'package:flutter/material.dart';
import 'package:route_creator/route_creator.dart';

import 'package:isen_ouest_companion/base/status_bar_color.dart';
import 'package:isen_ouest_companion/settings/settings_page.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const StatusBarColor(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context)
              .push(createRoute(const SettingsPage(), Direction.fromRight)),
          icon: const Icon(Icons.settings),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
