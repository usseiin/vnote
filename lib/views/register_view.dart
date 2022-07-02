import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vnote_app/services/auth/auth_exceptions.dart';
import 'package:vnote_app/services/auth/bloc/auth_bloc.dart';
import 'package:vnote_app/services/auth/bloc/auth_event.dart';
import 'package:vnote_app/services/auth/bloc/auth_state.dart';
import 'package:vnote_app/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is EmailAlreadyInUseAuthExcepton) {
            await showErrorDialog(context, "Email already in use");
          } else if (state.exception is WeakPasswordAuthExcepton) {
            await showErrorDialog(context, "Weak password");
          } else if (state.exception is NetworkRequestFaildAuthExcepton) {
            await showErrorDialog(context, "Network request failed");
          } else if (state.exception is GenericAuthExcepton) {
            await showErrorDialog(context, "Authentication error");
          } else if (state.exception is InvalidEmailAuthExcepton) {
            await showErrorDialog(context, "invalid email");
          }
        } else {}
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
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
                context.read<AuthBloc>().add(
                      AuthEventRegister(email, password),
                    );
              },
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text(
                "Already have an account? Signin",
              ),
            )
          ],
        ),
      ),
    );
  }
}
