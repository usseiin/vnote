import 'package:flutter/material.dart';
import 'package:vnote_app/constants/routes.dart';
import 'package:vnote_app/enum/menu_actions.dart';
import 'package:vnote_app/services/auth/auth_services.dart';

class NoteView extends StatelessWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NotesView"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              final navigator = Navigator.of(context);
              switch (value) {
                case MenuAction.logOut:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();
                    navigator.pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }

                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: MenuAction.logOut,
                  child: Text("Log out"),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Text("Hello World"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign out"),
        content: const Text("Are you sure you want to sign out"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
