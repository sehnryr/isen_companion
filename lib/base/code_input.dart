import 'package:flutter/material.dart';

import 'package:isen_companion/base/base_input.dart';

class CodeInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool error;

  const CodeInput({
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
      labelText: "N° Étudiant",
      errorText: "Veuillez indiquer un code valide",
      prefixIcon: const Icon(Icons.tag),
      error: error,
      onChanged: onChanged,
      outlined: true,
    );
  }
}
