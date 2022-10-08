import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:progress_hud/progress_hud.dart';

class Direction {
  static const Offset fromTop = Offset(0.0, -1.0);
  static const Offset fromBottom = Offset(0.0, 1.0);
  static const Offset fromLeft = Offset(-1.0, 0.0);
  static const Offset fromRight = Offset(1.0, 0.0);
}

class SlideOrGoRoute extends GoRoute {
  SlideOrGoRoute({
    required String path,
    Widget? target,
    Offset? direction,
    GoRouterRedirect? redirect,
  }) : super(
          path: path,
          builder: target != null
              ? (context, state) => _wrapper(context, child: target)
              : null,
          pageBuilder: target != null && direction != null
              ? (context, state) => CustomTransitionPage(
                    child: _wrapper(context, child: target),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = direction;
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween<Offset>(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  )
              : null,
          redirect: redirect,
        );

  static Widget _wrapper(BuildContext context, {required Widget child}) {
    return TapUnfocus(
      context,
      child: ProgressHUD(child: child),
    );
  }
}

class TapUnfocus extends GestureDetector {
  TapUnfocus(
    BuildContext context, {
    required Widget child,
  }) : super(
          child: child,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
        );
}
