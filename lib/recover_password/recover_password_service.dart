import 'package:requests/requests.dart';

import 'package:isen_ouest_companion/secure_storage.dart';

enum RecoverResponseCode {
  error,
  usernameError,
  codeError,
  success,
}

class RecoverPassword {
  const RecoverPassword();

  static const String serviceUrl =
      "https://web.isen-ouest.fr/password/sav/index.php?uri=/demande";

  static Future<RecoverResponseCode> sendRecoverRequest({
    required String username,
    required int code,
  }) async {
    try {
      String? proxyUrl = await SecureStorage.get(SecureStorageKey.proxyUrl);
      var response = await Requests.post("$proxyUrl$serviceUrl", body: {
        'identifiant': username,
        'code': code,
        'submit': null,
      });
      response.throwForStatus();

      if (RegExp(r"L'identifiant que vous avez saisi n'est pas valide !")
          .hasMatch(response.content())) {
        return RecoverResponseCode.usernameError;
      } else if (RegExp(r"Le code que vous avez saisi n'est pas valide !")
          .hasMatch(response.content())) {
        return RecoverResponseCode.codeError;
      }
      return RecoverResponseCode.success;
    } catch (e) {
      return RecoverResponseCode.error;
    }
  }
}
