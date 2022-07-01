import 'package:flutter/material.dart';
import 'package:vnote_app/constants/routes.dart';
import 'package:vnote_app/enum/menu_actions.dart';
import 'package:vnote_app/services/auth/auth_services.dart';
import 'package:vnote_app/services/crud/notes_services.dart';
import 'package:vnote_app/utilities/dialogs/logout_dialog.dart';
import 'package:vnote_app/views/notes/note_list_view.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NoteListView(
                          notes: allNotes,
                          onDeleteNote: (note) async {
                            await _notesService.deleteNote(id: note.id);
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              createOrUpdateNoteRoute,
                              arguments: note,
                            );
                          },
                        );
                      }
                      return const CircularProgressIndicator();
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}