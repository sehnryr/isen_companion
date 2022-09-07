import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class ProgressHUDWrapper extends StatelessWidget {
  final Widget child;

  const ProgressHUDWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      indicatorColor: Theme.of(context).colorScheme.primary,
      child: Builder(builder: (context) {
        return child;
      }),
    );
  }
}
