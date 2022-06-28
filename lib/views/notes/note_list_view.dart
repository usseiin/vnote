import 'package:flutter/material.dart';
import 'package:vnote_app/services/crud/notes_services.dart';
import 'package:vnote_app/utilities/dialogs/delete_dialog.dart';

typedef DeleteNoteCallback = Function(DatabaseNote note);

class NoteListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;
  const NoteListView(
      {Key? key, required this.notes, required this.onDeleteNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          onTap: () {},
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final showDelete = await showDeleteDialog(context);
              if (showDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
