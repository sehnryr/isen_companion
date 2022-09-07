import 'package:flutter/material.dart';

import 'package:isen_ouest_companion/base/base_constant.dart';

class BaseFooter extends StatelessWidget {
  final String text;

  const BaseFooter(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: padding,
      child: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.overline,
      )),
    );
  }
}
