import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarColor extends SystemUiOverlayStyle {
  const StatusBarColor()
      : super(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        );
}
