import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vnote_app/services/cloud/cloud_note.dart';
import 'package:vnote_app/services/cloud/cloud_services_extension.dart';
import 'package:vnote_app/services/cloud/cloud_storage_constant.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");

  FirebaseCloudStorage._();

  static final FirebaseCloudStorage _instance = FirebaseCloudStorage._();

  factory FirebaseCloudStorage() => _instance;

  Future<void> deleteNote({required documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String owerUserId}) {
    final allNote = notes
        .where(ownerUserIdFieldName, isEqualTo: owerUserId)
        .snapshots()
        .map((event) => event.docs.map((e) => CloudNote.fromSnapshot(e)));
    return allNote;
  }

  // Future<Iterable<CloudNote>> getNotes({required onwerUserId}) async {
  //   try {
  //     return await notes
  //         .where(ownerUserIdFieldName, isEqualTo: onwerUserId)
  //         .get()
  //         .then(
  //           (value) => value.docs.map(
  //             (doc) => CloudNote.fromSnapshot(doc),
  //             // CloudNote(
  //             //   documentId: doc.id,
  //             //   ownerUserId: doc.data()[ownerUserIdFieldName] as String,
  //             //   text: doc.data()[textFieldName] as String,
  //             // ),
  //           ),
  //         );
  //   } catch (e) {
  //     throw CouldNotGetAllNoteException();
  //   }
  // }

  Future<CloudNote> createNewNote({required ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: "",
    });
    final fetchNote = await document.get();
    return CloudNote(
      documentId: fetchNote.id,
      ownerUserId: ownerUserId,
      text: "",
    );
  }
}
