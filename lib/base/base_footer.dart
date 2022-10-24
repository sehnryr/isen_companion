import 'package:flutter/material.dart';

import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:isen_companion/base/base_constants.dart';

class BaseFooter extends StatelessWidget {
  final String text;

  const BaseFooter(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: padding,
      child: Center(
        child: StyledText(
          text: text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.overline,
          tags: {
            'link': StyledTextActionTag(
              (String? text, Map<String?, String?> attrs) {
                final String link = attrs['href'] ?? '';
                if (link.isNotEmpty) {
                  launchUrl(Uri.parse(link));
                }
              },
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          },
        ),
      ),
    );
  }
}
