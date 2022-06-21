import 'package:flutter/material.dart';
import 'package:vnote_app/constants/routes.dart';
import 'package:vnote_app/services/auth/auth_exceptions.dart';
import 'package:vnote_app/services/auth/auth_services.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            autocorrect: false,
            enableSuggestions: false,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          TextField(
            autocorrect: false,
            enableSuggestions: false,
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          TextButton(
            onPressed: () async {
              final String email = _email.text;
              final String password = _password.text;
              final navigator = Navigator.of(context);

              try {
                await AuthService.firebase().login(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user!.isEmailVerified) {
                  navigator.pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  navigator.pushNamed(verifyEmailRoute);
                }
              } on UserNotFoundAuthExcepton {
                await showErrorDialog(
                  context,
                  "User not found",
                );
              } on WrongPasswordAuthExcepton {
                await showErrorDialog(
                  context,
                  "Wrong password",
                );
              } on NetworkRequestFaildAuthExcepton {
                await showErrorDialog(
                  context,
                  "Network request failed",
                );
              } on GenericAuthExcepton {
                await showErrorDialog(
                  context,
                  "Authentication Error",
                );
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text(
              "Don't have an account? Signup here",
            ),
          )
        ],
      ),
    );
  }
}
