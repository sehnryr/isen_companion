import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:isen_ouest_companion/base/base_constant.dart';
import 'package:isen_ouest_companion/base/code_input.dart';
import 'package:isen_ouest_companion/base/username_input.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_send_link_button.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_app_bar.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_footer.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_service.dart';

class RecoverPasswordPage extends StatefulWidget {
  final TextEditingController? usernameController;

  const RecoverPasswordPage({Key? key, this.usernameController})
      : super(key: key);

  @override
  RecoverPasswordPageState createState() => RecoverPasswordPageState();
}

class RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late TextEditingController usernameController;
  late TextEditingController codeController;
  late FToast fToast;
  bool usernameError = false;
  bool codeError = false;

  @override
  void initState() {
    usernameController = widget.usernameController ?? TextEditingController();
    codeController = TextEditingController();
    super.initState();

    fToast = FToast();
    fToast.init(context);
  }

  void _showToast(String text,
      {Duration duration = const Duration(seconds: 2)}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Theme.of(context).colorScheme.primary.withAlpha(192)),
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );

    fToast.removeQueuedCustomToasts();

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: const RecoverPasswordAppBar(),
        body: Container(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Mot de passe oublié ?",
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Indiquez votre identifiant et code¹ et recevez un lien par mail pour réinitialiser votre mot de passe.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              UsernameInput(
                controller: usernameController,
                error: usernameError,
                onChanged: (String string) => setState(() => usernameError =
                    string.isEmpty || !RegExp(r'^[a-z0-9]+$').hasMatch(string)),
              ),
              CodeInput(
                controller: codeController,
                error: codeError,
                onChanged: (String string) => setState(() => codeError =
                    string.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(string)),
              ),
              SendLinkButton(onPressed: () {
                if (usernameController.text.isEmpty) {
                  setState(() => usernameError = true);
                }
                if (codeController.text.isEmpty) {
                  setState(() => codeError = true);
                }
                if (usernameController.text.isEmpty &&
                    codeController.text.isEmpty) {
                  return;
                }

                final username = usernameController.text;
                final code = int.parse(codeController.text);

                Future<RecoverResponseCode> responseCode =
                    RecoverPassword.sendRecoverRequest(
                  username: username,
                  code: code,
                );

                responseCode.then((value) {
                  switch (value) {
                    case RecoverResponseCode.Error:
                    case RecoverResponseCode.UsernameError:
                      setState(() => usernameError = true);
                      break;
                    case RecoverResponseCode.CodeError:
                      setState(() => codeError = true);
                      break;
                    case RecoverResponseCode.Success:
                    default:
                      _showToast("Un email vous à été envoyé.",
                          duration: const Duration(seconds: 4));
                      Navigator.of(context).pop();
                      break;
                  }
                });
              }),
            ],
          ),
        ),
        bottomNavigationBar: const RecoverPasswordFooter(),
      ),
    );
  }
}
