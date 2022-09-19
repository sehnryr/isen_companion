import 'package:flutter/material.dart';

import 'package:isen_ouest_companion/aurion.dart';
import 'package:isen_ouest_companion/settings/list_tiles/service_url/service_url_input.dart';

class ServiceUrlDialog extends StatefulWidget {
  final TextEditingController controller;
  final String title;

  const ServiceUrlDialog({
    required this.controller,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  ServiceUrlDialogState createState() => ServiceUrlDialogState();
}

class ServiceUrlDialogState extends State<ServiceUrlDialog> {
  late String text;
  late bool error;

  @override
  void initState() {
    text = widget.controller.text;
    error = !_validation(text);
    super.initState();
  }

  bool _validation(String text) {
    return text.isNotEmpty ||
        RegExp(r'https?:\/\/[^\/]+\.\w{2,}\/?.*\/$').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: [
        SimpleDialogOption(
            child: ServiceUrlInput(
          controller: widget.controller,
          error: error,
          onChanged: (String text) =>
              setState(() => error = !_validation(text.trim())),
        )),
        SimpleDialogOption(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                // reset controller text
                widget.controller.text = text;
                Navigator.pop(context, 'Annuler');
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                error = !_validation(widget.controller.text);
                if (!error) {
                  text = widget.controller.text.trim();
                  Aurion.init(text).then((_) => Navigator.pop(context, 'OK'));
                }
              },
              child: const Text('OK'),
            ),
          ],
        ))
      ],
    );
  }
}
