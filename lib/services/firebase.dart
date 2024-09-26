import "package:cloud_firestore/cloud_firestore.dart";

class FirebaseService {
  CollectionReference messages =
      FirebaseFirestore.instance.collection("messages");

  createCode(String firstname, String lastname, String message) async {
    await messages
        .add({"firstname": firstname, "lastname": lastname, "message": message})
        .then((value) => print("Message inséreés avec success"))
        .catchError((error) => print("Une erreur $error"));
  }

  Stream<QuerySnapshot> getMessages() {
    final getMessages = messages.snapshots();
    return getMessages;
  }

  Future<void> deleteMessage(String idMessage) async {
    await messages
        .doc(idMessage)
        .delete()
        .then((value) => print("Message supprimé avec succès"))
        .catchError((error) => print("Une erreur $error"));
  }

  Future<void> updateMessage(String idMessage, String message, String firstname, String lastname) async {
    await messages
        .doc(idMessage)
        .update({
          "firstname": firstname,
          "lastname": lastname,
          "message": message
        })
        .then((value) => print("Message mis à jour avec succès"))
        .catchError((error) => print("Une erreur $error"));
  }
}
