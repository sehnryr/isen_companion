import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:isen_ouest_companion/base/status_bar_color.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const StatusBarColor(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        onPressed: () =>
            context.canPop() ? context.pop() : context.go('/login'),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text("Paramètres"),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
