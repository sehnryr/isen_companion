import 'package:flutter/material.dart';
import 'package:isen_ouest_companion/login/login_footer.dart';
import 'package:isen_ouest_companion/login/login_icon.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_page.dart';
import 'package:route_creator/route_creator.dart';

import 'package:isen_ouest_companion/base/base_constants.dart';
import 'package:isen_ouest_companion/base/password_input.dart';
import 'package:isen_ouest_companion/base/username_input.dart';
import 'package:isen_ouest_companion/login/login_button.dart';
import 'package:isen_ouest_companion/recover_password/recover_password_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                // if (usernameError || passwordError) {
                //   if (usernameError) {
                //     setState(() => usernameError = usernameError);
                //   }
                //   if (passwordError) {
                //     setState(() => passwordError = passwordError);
                //   }
                // } else {
                //   final progress = ProgressHUD.of(context);
                //   progress?.show();
                //   try {
                //     final bool loginState =
                //         await Aurion.login(username, password);
                //     if (!loginState) {
                //       const snackBar = SnackBar(
                //         behavior: SnackBarBehavior.floating,
                //         content: Text("Échec de l'authentification"),
                //       );
                //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //     } else {
                //       await Aurion.fetchSchedule();
                //       final String? schedule =
                //           await SecureStorage.getSchedule();
                //       Navigator.of(context).pushReplacement(createRoute(
                //         ScheduleScreen(
                //             schedule: schedule != null
                //                 ? json.decode(schedule)
                //                 : null),
                //         Direction.fromRight,
                //       ));
                //     }
                //   } on TimeoutException {
                //     const snackBar = SnackBar(
                //       behavior: SnackBarBehavior.floating,
                //       content: Text("Temps d'attente dépassé"),
                //     );
                //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //   }
                //   progress?.dismiss();
                // }
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
