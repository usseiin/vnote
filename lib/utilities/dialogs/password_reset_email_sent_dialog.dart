import 'package:flutter/material.dart';
import 'package:vnote_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Password Reset",
    content:
        "We have sent you a reset password reset link. Please check your email for more information",
    optionsBuilder: () => {
      "Ok": null,
    },
  );
}
