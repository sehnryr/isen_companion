import 'package:requests/requests.dart';

import 'package:isen_ouest_companion/secure_storage.dart';

class RecoverResponseCode {
  final String _value;
  const RecoverResponseCode._internal(this._value);
  @override
  toString() => 'RecoverResponseCode.$_value';

  static const Error = RecoverResponseCode._internal('Error');
  static const UsernameError = RecoverResponseCode._internal('UsernameError');
  static const CodeError = RecoverResponseCode._internal('CodeError');
  static const Success = RecoverResponseCode._internal('Success');
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
      String proxyUrl =
          await SecureStorage.get(SecureStorageKey.CORSProxy) ?? "";
      var response = await Requests.post("$proxyUrl$serviceUrl", body: {
        'identifiant': username,
        'code': code,
        'submit': null,
      });
      response.throwForStatus();

      if (RegExp(r"L'identifiant que vous avez saisi n'est pas valide !")
          .hasMatch(response.content())) {
        return RecoverResponseCode.UsernameError;
      } else if (RegExp(r"Le code que vous avez saisi n'est pas valide !")
          .hasMatch(response.content())) {
        return RecoverResponseCode.CodeError;
      }
      return RecoverResponseCode.Success;
    } catch (e) {
      return RecoverResponseCode.Error;
    }
  }
}
