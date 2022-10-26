import 'package:flutter/material.dart';

import 'package:isen_companion/storage.dart';
import 'package:isen_companion/settings/settings_app_bar.dart';
import 'package:isen_companion/settings/list_tiles/cors_proxy/cors_proxy_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController proxyController;

  @override
  void initState() {
    proxyController = TextEditingController();
    Storage.get(StorageKey.proxyUrl).then((value) => setState(() {
          proxyController.text = value!;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Réseau",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            dense: true,
          ),
          CorsProxyTile(
            controller: proxyController,
            onClose: () =>
                setState(() => proxyController.text = proxyController.text),
          ),
        ],
      ),
    );
  }
}
