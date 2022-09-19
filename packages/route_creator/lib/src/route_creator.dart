import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';

class Direction {
  static const Offset fromTop = Offset(0.0, -1.0);
  static const Offset fromBottom = Offset(0.0, 1.0);
  static const Offset fromLeft = Offset(-1.0, 0.0);
  static const Offset fromRight = Offset(1.0, 0.0);
}

Route createRoute(Widget page, Offset direction) => PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ProgressHUD(child: page),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = direction;
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    );
