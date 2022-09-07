import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart' as fph;

class ProgressHUD extends StatelessWidget {
  final Widget child;

  const ProgressHUD({Key? key, required this.child}) : super(key: key);

  dynamic of(BuildContext context) {
    return fph.ProgressHUD.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return fph.ProgressHUD(
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      indicatorColor: Theme.of(context).colorScheme.primary,
      child: Builder(builder: (context) {
        return child;
      }),
    );
  }
}
