import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vnote_app/services/auth/bloc/auth_bloc.dart';
import 'package:vnote_app/services/auth/bloc/auth_event.dart';
import 'package:vnote_app/services/auth/bloc/auth_state.dart';
import 'package:vnote_app/utilities/dialogs/error_dialog.dart';
import 'package:vnote_app/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgetPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }

          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(
              context,
              "we could not process your request. Please make sure tou are registered user, if not, register by going one step backward",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forget Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "If you forget your password, Kindly provide your email and we will send you a password reset link.",
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Your email address",
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgetPassword(email: email));
                },
                child: const Text("send me password reset link"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text("Back to Login Page"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
