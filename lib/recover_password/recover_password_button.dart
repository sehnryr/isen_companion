import 'package:flutter/material.dart';

class RecoverPasswordButton extends StatelessWidget {
  final void Function() onPressed;

  const RecoverPasswordButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text("Mot de passe oublié ?"),
    );
  }
}
