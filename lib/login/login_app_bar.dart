import 'package:flutter/material.dart';

import 'package:isen_ouest_companion/base/status_bar_color.dart';

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
          onPressed: () => Navigator.of(context).pushNamed('/settings'),
          icon: const Icon(Icons.settings),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
