import 'package:firebase_flutter/services/firebase.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  Color color = Colors.teal;

  void showCodeDialog(String? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Envoyez-moi un message d'amour à Abondance",
            style: TextStyle(fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    cursorColor: color,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                    ),
                    controller: firstnameController,
                    decoration: InputDecoration(
                      labelText: "Votre prénom",
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: color,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextField(
                    cursorColor: color,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                    ),
                    controller: lastnameController,
                    decoration: InputDecoration(
                      labelText: "Votre nom",
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: color,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextField(
                    cursorColor: color,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                    ),
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Message",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: color,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('Envoyer'),
              onPressed: () {
                String firstname = firstnameController.text;
                String lastname = lastnameController.text;
                String message = messageController.text;
                id != null
                    ? FirebaseService().updateMessage(
                        id,
                        messageController.text,
                        firstnameController.text,
                        lastnameController.text)
                    : FirebaseService()
                        .createCode(firstname, lastname, message);
                messageController.clear();
                firstnameController.clear();
                lastnameController.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
                messageController.clear();
                firstnameController.clear();
                lastnameController.clear();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mon Abondance",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder(
        stream: FirebaseService().getMessages(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Aucun message d'amour trouvé",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 198, 198, 198),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    title: Text(snapshot.data!.docs[index]["message"]),
                    subtitle: Text(snapshot.data!.docs[index]["firstname"] +
                        " " +
                        snapshot.data!.docs[index]["lastname"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            String id = snapshot.data!.docs[index].id;
                            messageController.text =
                                snapshot.data!.docs[index]["message"];
                            lastnameController.text =
                                snapshot.data!.docs[index]["lastname"];
                            firstnameController.text =
                                snapshot.data!.docs[index]["firstname"];
                            showCodeDialog(id);
                          },
                          color: Colors.red,
                          icon: CircleAvatar(
                            radius: 15.0,
                            backgroundColor: color,
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 15),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            String id = snapshot.data!.docs[index].id;
                            FirebaseService().deleteMessage(id);
                          },
                          icon: const CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.delete,
                                color: Colors.white, size: 15),
                          ),
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: color,
                      child: Text(
                        "${snapshot.data!.docs[index]["firstname"][0]}${snapshot.data!.docs[index]["lastname"][0]}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCodeDialog(null);
        },
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
