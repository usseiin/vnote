import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vnote_app/constants/routes.dart';
import 'package:vnote_app/services/auth/auth_exceptions.dart';
import 'package:vnote_app/services/auth/bloc/auth_bloc.dart';
import 'package:vnote_app/services/auth/bloc/auth_event.dart';
import 'package:vnote_app/services/auth/bloc/auth_state.dart';
import 'package:vnote_app/utilities/dialogs/error_dialog.dart';

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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundAuthExcepton) {
                  await showErrorDialog(context, "User not found");
                } else if (state.exception is WrongPasswordAuthExcepton) {
                  await showErrorDialog(context, "Wrong credential");
                } else if (state.exception is NetworkRequestFaildAuthExcepton) {
                  await showErrorDialog(context, "Network requset failed");
                } else if (state.exception is GenericAuthExcepton) {
                  await showErrorDialog(context, "Authentication error");
                }
              }
            },
            child: TextButton(
              onPressed: () async {
                final String email = _email.text;
                final String password = _password.text;
                context.read<AuthBloc>().add(AuthEventLogIn(email, password));
              },
              child: const Text("Login"),
            ),
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
