import 'package:flutter/material.dart';

import 'package:isen_ouest_companion/base/base_button.dart';

class SendLinkButton extends StatelessWidget {
  final void Function() onPressed;

  const SendLinkButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      text: "ENVOYER LE LIEN",
      onPressed: onPressed,
    );
  }
}
