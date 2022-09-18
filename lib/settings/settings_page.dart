import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:secure_storage/secure_storage.dart';

import 'package:isen_ouest_companion/settings/settings_constants.dart';
import 'package:isen_ouest_companion/settings/settings_app_bar.dart';
import 'package:isen_ouest_companion/settings/list_tiles/cors_proxy/cors_proxy_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late TextEditingController proxyController;

  @override
  void initState() {
    proxyController = TextEditingController()
      ..addListener(
          () => setState(() => proxyController.text = proxyController.text));
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
    super.initState();
  }

  @override
  void dispose() {
    proxyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Network",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            dense: true,
          ),
          ListTile(
            title: const Text(
              "CORS bypass proxy",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(proxyController.text.isNotEmpty
                ? proxyController.text
                : "None"),
            trailing: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CORSProxyDialog(
                    controller: proxyController,
                    title: "CORS bypass proxy",
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}