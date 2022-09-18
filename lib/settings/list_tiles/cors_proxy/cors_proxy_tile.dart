import 'package:flutter/material.dart';

import 'package:isen_ouest_companion/settings/list_tiles/cors_proxy/cors_proxy_dialog.dart';

class CorsProxyTile extends StatelessWidget {
  final TextEditingController controller;
  final void Function() onClose;

  const CorsProxyTile({
    Key? key,
    required this.controller,
    required this.onClose,
  }) : super(key: key);

  final String title = "CORS bypass proxy";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(controller.text.isNotEmpty ? controller.text : "Aucun"),
      trailing: Icon(
        Icons.edit,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CORSProxyDialog(
              controller: controller,
              title: title,
            );
          },
        ).then((_) => onClose());
      },
    );
  }
}
