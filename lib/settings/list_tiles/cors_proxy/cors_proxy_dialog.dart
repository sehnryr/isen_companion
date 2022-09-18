import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

import 'package:isen_ouest_companion/settings/list_tiles/cors_proxy/cors_proxy_input.dart';

class CORSProxyDialog extends StatefulWidget {
  final TextEditingController controller;
  final String title;

  const CORSProxyDialog({
    required this.controller,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  CORSProxyDialogState createState() => CORSProxyDialogState();
}

class CORSProxyDialogState extends State<CORSProxyDialog> {
  String proxy = "";
  bool proxyError = false;

  @override
  void initState() {
    proxy = widget.controller.text;
    super.initState();
  }

  bool _proxyValidation(String proxy) {
    return proxy.isEmpty ||
        RegExp(r'https?:\/\/[^\/]+\.\w{2,}\/?.*[\/?=]$').hasMatch(proxy);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: [
        SimpleDialogOption(
            child: CORSProxyInput(
          controller: widget.controller,
          error: proxyError,
          onChanged: (String proxy) =>
              setState(() => proxyError = !_proxyValidation(proxy)),
        )),
        SimpleDialogOption(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                // reset controller text
                widget.controller.text = proxy;
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                proxyError = !_proxyValidation(widget.controller.text);
                if (!proxyError) {
                  proxy = widget.controller.text.trim();
                  SecureStorage.set(SecureStorageKey.CORSProxy, proxy)
                      .then((value) {
                    setState(() {
                      widget.controller.text = proxy;
                    });
                    Navigator.pop(context, 'OK');
                  });
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
