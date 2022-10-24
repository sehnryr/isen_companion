import 'package:flutter/material.dart';

import 'package:isen_companion/base/base_footer.dart';

const String _url =
    'https://github.com/sehnryr/isen_companion#politique-de-confidentialité';

class LoginFooter extends BaseFooter {
  const LoginFooter({Key? key})
      : super(
          'Cette application est à l&apos;usage exclusif des étudiants de l&apos;ISEN. En utilisant cette application, vous acceptez notre <link href="$_url">Politique de Confidentialité</link>.',
          key: key,
        );
}
