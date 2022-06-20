import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vnote_app/constants/routes.dart';

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
              final user = FirebaseAuth.instance.currentUser;
              await user!.sendEmailVerification();
            },
            child: const Text(
              "Send email verification",
            ),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await FirebaseAuth.instance.signOut();
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
