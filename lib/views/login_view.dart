import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthExcepton) {
            await showErrorDialog(
                context, "Cannot find a user with the enter credentials");
          } else if (state.exception is WrongPasswordAuthExcepton) {
            await showErrorDialog(context, "Wrong credential");
          } else if (state.exception is NetworkRequestFaildAuthExcepton) {
            await showErrorDialog(context, "Network requset failed");
          } else if (state.exception is GenericAuthExcepton) {
            await showErrorDialog(context, "Authentication error");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  "Please log into your account in order to interact with and create note"),
              TextField(
                autofocus: true,
                autocorrect: false,
                enableSuggestions: false,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),
              TextField(
                autofocus: true,
                autocorrect: false,
                enableSuggestions: false,
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgetPassword(),
                      );
                },
                child: const Text(
                  "I forget my password",
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text(
                  "Don't have an account? Signup here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
