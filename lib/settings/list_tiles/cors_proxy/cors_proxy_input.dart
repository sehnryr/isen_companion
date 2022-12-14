import 'package:flutter/material.dart';

import 'package:isen_companion/base/base_input.dart';

class CORSProxyInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool error;

  const CORSProxyInput({
    Key? key,
    required this.controller,
    this.error = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseInput(
      controller: controller,
      hintText: "Aucun",
      errorText: "L'url n'est pas valide (http, https).",
      error: error,
      onChanged: onChanged,
      height: null,
    );
  }
}
