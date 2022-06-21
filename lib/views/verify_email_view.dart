import 'package:flutter/material.dart';
import 'package:vnote_app/constants/routes.dart';
import 'package:vnote_app/services/auth/auth_services.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          const Text(
            "We've send you an email Verification, please open it to verify your account",
          ),
          const Text(
            'If you haven\'t received averification eail yet, press the button below',
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text(
              "Send email verification",
            ),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await AuthService.firebase().logOut();
              navigator.pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text(
              "Restart",
            ),
          ),
        ],
      ),
    );
  }
}
