import 'package:flutter/material.dart';

import 'package:isen_ouest_companion/base/base_input.dart';

class UsernameInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool error;

  const UsernameInput({
    Key? key,
    required this.controller,
    this.error = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseInput(
      controller: controller,
      autofillHints: const [AutofillHints.username],
      labelText: "Identifiant",
      errorText: "Veuillez indiquer un identifiant valide",
      prefixIcon: const Icon(Icons.person),
      error: error,
      onChanged: onChanged,
    );
  }
}

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool error;

  const PasswordInput({
    Key? key,
    required this.controller,
    this.error = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseInput(
      controller: controller,
      autofillHints: const [AutofillHints.password],
      labelText: "Mot de passe",
      errorText: "Veuillez indiquer un mot de passe valide",
      prefixIcon: const Icon(Icons.lock_open),
      isPassword: true,
      error: error,
      onChanged: onChanged,
    );
  }
}
