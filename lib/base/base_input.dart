import 'package:flutter/material.dart';

import 'package:isen_companion/base/base_constants.dart';

class BaseInput extends StatefulWidget {
  final TextEditingController controller;
  final Iterable<String>? autofillHints;
  final void Function(String)? onChanged;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Icon? prefixIcon;
  final bool isPassword;
  final double? height;
  final bool outlined;
  final bool error;

  const BaseInput({
    Key? key,
    required this.controller,
    this.errorText,
    this.labelText,
    this.hintText,
    this.autofillHints,
    this.prefixIcon,
    this.onChanged,
    this.height = 90.0,
    this.isPassword = false,
    this.outlined = false,
    this.error = false,
  }) : super(key: key);

  @override
  State<BaseInput> createState() => _BaseInputState();
}

class _BaseInputState extends State<BaseInput> {
  final FocusNode _focusNode = FocusNode();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: TextFormField(
        onChanged: widget.onChanged,
        focusNode: _focusNode,
        autofillHints: widget.autofillHints,
        controller: widget.controller,
        obscureText: widget.isPassword ? !_showPassword : false,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          errorText: widget.error ? widget.errorText : null,
          border: widget.outlined
              ? OutlineInputBorder(
                  borderRadius: borderRadius,
                )
              : null,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    if (!_focusNode.hasPrimaryFocus) {
                      _focusNode.unfocus();
                      _focusNode.canRequestFocus = false;
                    }
                    setState(() => _showPassword = !_showPassword);
                  },
                )
              : null,
        ),
      ),
    );
  }
}
