import 'package:flutter/material.dart';

import 'package:isen_companion/base/base_button.dart';

class LoginButton extends StatelessWidget {
  final void Function() onPressed;

  const LoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      text: "CONNEXION",
      onPressed: onPressed,
    );
  }
}
