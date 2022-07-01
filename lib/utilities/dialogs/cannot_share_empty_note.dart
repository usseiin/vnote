import 'package:flutter/cupertino.dart';
import 'package:vnote_app/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Share',
    content: 'You cannot share empty note!',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
