import 'dart:async';

import 'package:flutter/material.dart';

import 'package:isen_aurion_client/isen_aurion_client.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:route_creator/route_creator.dart';

import 'package:isen_ouest_companion/aurion.dart';
import 'package:isen_ouest_companion/base/base_constants.dart';
import 'package:isen_ouest_companion/base/password_input.dart';
import 'package:isen_ouest_companion/base/username_input.dart';
import 'package:isen_ouest_companion/login/login_app_bar.dart';
import 'package:isen_ouest_companion/login/login_button.dart';
import 'package:isen_ouest_companion/login/login_footer.dart';
import 'package:isen_ouest_companion/login/login_icon.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_button.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_page.dart';
import 'package:isen_ouest_companion/schedule/schedule_page.dart';
import 'package:isen_ouest_companion/storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  bool usernameError = false;
  bool passwordError = false;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    Storage.get(StorageKey.username).then((username) async {
      if (username != null) {
        usernameController.text = username;
        String? password = await Storage.get(StorageKey.password);
        if (password != null) {
          passwordController.text = "Vous n'êtes pas sensé voir ça...";
          login(usernameController.text, password);
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _usernameValidation(String username) {
    return username.isNotEmpty || RegExp(r'[a-z0-9]{6:}$').hasMatch(username);
  }

  bool _passwordValidation(String password) {
    return password.isNotEmpty || RegExp(r'^[ ]{6:}$').hasMatch(password);
    // TODO: get the correct regex string for the password
  }

  void login(String username, String password) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    try {
      await Aurion.login(username, password)
          .timeout(const Duration(seconds: 20));

      Navigator.of(context).pushReplacement(createRoute(
        const SchedulePage(),
        Direction.fromRight,
      ));
    } on AuthenticationException {
      const snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Échec de l'authentification"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on TimeoutException {
      SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: const Text("Temps d'attente dépassé"),
        action: SnackBarAction(
          label: "Réessayer",
          onPressed: () => login(username, password),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    progress?.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LoginAppBar(),
      body: Container(
        padding: padding,
        child: AutofillGroup(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const AppIcon(),
              const SizedBox(height: 50),
              UsernameInput(
                controller: usernameController,
                error: usernameError,
                onChanged: (String username) => setState(
                    () => usernameError = !_usernameValidation(username)),
              ),
              PasswordInput(
                controller: passwordController,
                error: passwordError,
                onChanged: (String password) => setState(
                    () => passwordError = !_passwordValidation(password)),
              ),
              LoginButton(onPressed: () async {
                FocusScope.of(context).unfocus(); // Close the keyboard

                final username = usernameController.text;
                final password = passwordController.text;

                usernameError = !_usernameValidation(username);
                passwordError = !_passwordValidation(password);

                if (usernameError || passwordError) {
                  if (usernameError) {
                    setState(() => usernameError = usernameError);
                  }
                  if (passwordError) {
                    setState(() => passwordError = passwordError);
                  }
                } else {
                  login(username, password);
                }
              }),
              RecoverPasswordButton(onPressed: () {
                FocusScope.of(context).unfocus();

                setState(() {
                  if (usernameError) {
                    usernameError = usernameController.text.isNotEmpty;
                  }
                  if (passwordError) {
                    passwordError = passwordController.text.isNotEmpty;
                  }
                });
                Navigator.of(context).push(createRoute(
                    RecoverPasswordPage(
                      usernameController: usernameController,
                    ),
                    Direction.fromBottom));
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const LoginFooter(),
      extendBody: true,
    );
  }
}
