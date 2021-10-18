// ignore_for_file: unnecessary_new, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables
// @dart=2.9

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AjoutQuestion extends StatefulWidget {
  AjoutQuestion({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AjoutQuestionState createState() => AjoutQuestionState();
}

class AjoutQuestionState extends State<AjoutQuestion> {
  final databaseReference = Firestore.instance;

  final controllerquestion = TextEditingController();
  final controlleroption1 = TextEditingController();
  final controlleroption2 = TextEditingController();
  final controllerreponse = TextEditingController();
  final controllertheme = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              controller: controllerquestion,
              // ignore: deprecated_member_use
              cursorColor: Theme.of(context).cursorColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Question',
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextFormField(
              controller: controlleroption1,
              // ignore: deprecated_member_use
              cursorColor: Theme.of(context).cursorColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Première option',
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextFormField(
              controller: controlleroption2,
              // ignore: deprecated_member_use
              cursorColor: Theme.of(context).cursorColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Deuxième option',
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextFormField(
              controller: controllerreponse,
              // ignore: deprecated_member_use

              cursorColor: Theme.of(context).cursorColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Réponse',
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextFormField(
              controller: controllertheme,
              // ignore: deprecated_member_use

              cursorColor: Theme.of(context).cursorColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Thème',
                labelStyle: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  databaseReference.collection("questions").add({
                    "option1": controlleroption1.text.toString(),
                    "option2": controlleroption2.text.toString(),
                    "reponse": controllerreponse.text.toString(),
                    "texte": controllerquestion.text.toString(),
                    "theme": controllertheme.text.toString()
                  }).then((value) {});
                  databaseReference
                      .collection("theme")
                      .add({"value": controllertheme.text.toString()}).then(
                          (value) {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Question ajoutée à la base de données"),
                    ),
                  );
                },
                child: Text("Ajouter la question")),
          ],
        ),
      ),
    );
  }
}
