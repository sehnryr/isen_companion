import 'package:flutter/material.dart';

import 'package:isen_ouest_companion/settings/list_tiles/service_url/service_url_dialog.dart';

class ServiceUrlTile extends StatelessWidget {
  final TextEditingController controller;
  final void Function() onClose;

  const ServiceUrlTile({
    Key? key,
    required this.controller,
    required this.onClose,
  }) : super(key: key);

  final String title = "Service url";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(controller.text.isNotEmpty ? controller.text : "None"),
      trailing: Icon(
        Icons.edit,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ServiceUrlDialog(
              controller: controller,
              title: title,
            );
          },
        ).then((_) => onClose());
      },
    );
  }
}
