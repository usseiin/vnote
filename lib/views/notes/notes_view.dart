import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vnote_app/constants/routes.dart';
import 'package:vnote_app/enum/menu_actions.dart';
import 'package:vnote_app/services/auth/auth_services.dart';
import 'package:vnote_app/services/auth/bloc/auth_bloc.dart';
import 'package:vnote_app/services/auth/bloc/auth_event.dart';
import 'package:vnote_app/services/cloud/cloud_note.dart';
import 'package:vnote_app/services/cloud/firebase_cloud-storage.dart';
import 'package:vnote_app/utilities/dialogs/logout_dialog.dart';
import 'package:vnote_app/views/notes/note_list_view.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
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
              switch (value) {
                case MenuAction.logOut:
                  final shouldLogOut = await showLogOutDialog(context);

                  if (shouldLogOut) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(const AuthEventLogOut());
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
      body: StreamBuilder(
        stream: _notesService.allNotes(owerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NoteListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
