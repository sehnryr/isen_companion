import 'package:flutter/material.dart';

import 'package:isen_ouest_companion/base/base_input.dart';

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
      hintText: "None",
      errorText: "Unrecognized scheme (http, https).",
      error: error,
      onChanged: onChanged,
      height: null,
    );
  }
}
