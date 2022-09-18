import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:secure_storage/secure_storage.dart';

import 'package:isen_ouest_companion/settings/settings_constants.dart';
import 'package:isen_ouest_companion/settings/settings_app_bar.dart';
import 'package:isen_ouest_companion/settings/list_tiles/cors_proxy/cors_proxy_tile.dart';
import 'package:isen_ouest_companion/settings/list_tiles/service_url/service_url_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late TextEditingController proxyController;
  late TextEditingController serviceUrlController;

  @override
  void initState() {
    proxyController = TextEditingController();
    SecureStorage.get(SecureStorageKey.CORSProxy).then((value) async {
      setState(() {
        proxyController.text =
            value ?? (kIsWeb ? DefaultSettings.defaultProxy : "");
      });
      if (value == null) {
        await SecureStorage.set(
          SecureStorageKey.CORSProxy,
          proxyController.text,
        );
      }
    });
    serviceUrlController = TextEditingController();
    SecureStorage.get(SecureStorageKey.ServiceUrl).then((value) async {
      setState(() {
        serviceUrlController.text = value ?? DefaultSettings.defaultServiceUrl;
      });
      if (value == null) {
        await SecureStorage.set(
          SecureStorageKey.ServiceUrl,
          serviceUrlController.text,
        );
      }
    });
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
          ServiceUrlTile(
            controller: serviceUrlController,
            onClose: () => setState(
                () => serviceUrlController.text = serviceUrlController.text),
          )
        ],
      ),
    );
  }
}
