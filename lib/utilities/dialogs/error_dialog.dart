import 'package:flutter/material.dart';
import 'package:vnote_app/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: "An error occur",
    content: text,
    optionsBuilder: () => {
      "Ok": null,
    },
  );
}
