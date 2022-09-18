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
  late String proxy;
  late bool proxyError;

  @override
  void initState() {
    proxy = widget.controller.text;
    proxyError = !_proxyValidation(proxy);
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
              setState(() => proxyError = !_proxyValidation(proxy.trim())),
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
