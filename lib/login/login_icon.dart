import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  final double width;
  final double height;

  const AppIcon({
    Key? key,
    this.width = 70,
    this.height = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/images/logo_hat.svg",
      color: Theme.of(context).colorScheme.primary,
      width: width,
      height: height,
    );
  }
}
