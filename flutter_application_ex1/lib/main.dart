// ignore_for_file: unnecessary_new, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables
// @dart=2.9

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ajoutquestion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Questions/Réponses',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(title: 'Questions-Réponses'),
        routes: <String, WidgetBuilder>{
          '/AjoutQuestion': (BuildContext context) =>
              AjoutQuestion(title: 'Ajout de Question'),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = Firestore.instance;
  String defaultchoice = "Maths";
  String option1 = "2";
  String option2 = "5";
  String next = "";
  String question = "combien fait 1 + 1 ?";
  int index = 0;
  List listquestion = ["combien fait 1 + 1 ?"];

  List listoption1 = ["2"];
  List listoption2 = ["5"];
  List listcorrectans = ["2"];
  var listTheme = <String>[];

  void getThemes() {
    var ltheme = <String>[];
    databaseReference
        .collection("theme")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (var f in snapshot.documents) {
        Map<String, dynamic> theme = f.data;

        if (!ltheme.contains(theme['value'])) {
          ltheme.add(theme['value']);
        }
      }
      setState(() {
        listTheme.clear();
        listTheme.addAll(ltheme);
      });
    });
  }

  void getQuestions(String val) {
    List lq = <String>[];
    List lo1 = <String>[];
    List lo2 = <String>[];
    List rep = <String>[];

    databaseReference
        .collection("questions")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (var f in snapshot.documents) {
        Map<String, dynamic> question = f.data;
        if (question['theme'].toString() == val) {
          lq.add(question['texte'].toString());
          lo1.add(question['option1'].toString());
          lo2.add(question['option2'].toString());
          rep.add(question['reponse'].toString());
        }
      }
      setState(() {
        index = 0;

        listquestion.clear();
        listquestion.addAll(lq);
        listoption1.clear();
        listoption1.addAll(lo1);
        listoption2.clear();
        listoption2.addAll(lo2);
        listcorrectans.clear();
        listcorrectans.addAll(rep);
      });
    });
  }

  void ifCorrectAnswer(String ans) {
    if (ans == listcorrectans[index]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Réponse correcte !"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Réponse incorrecte !"),
        ),
      );
    }

    setState(() {
      if (index == listquestion.length - 1) {
        index = 0;
      } else {
        index++;
      }
    });
  }

  void incrementindex() {
    setState(() {
      if (index == listquestion.length - 1) {
        index = 0;
      } else {
        index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getThemes();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/AjoutQuestion');
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                    iconSize: 35.0,
                  ),
                  DropdownButton<String>(
                    value: defaultchoice,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    style: const TextStyle(color: Colors.teal),
                    underline: Container(
                      height: 3,
                      color: Colors.teal,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        defaultchoice = newValue;
                        index = 0;
                        getQuestions(newValue);
                      });
                    },
                    items:
                        listTheme.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ]),
            new Container(
                width: 350.0,
                height: 150.0,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://viralsolutions.net/wp-content/uploads/2019/06/shutterstock_749036344.jpg")))),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              width: 300,
              height: 150,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                  color: Colors.blue,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                      bottomLeft: const Radius.circular(20.0),
                      bottomRight: const Radius.circular(20.0))),
              child: Text(
                listquestion[index],
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(listoption1[index].toString()),
                  onPressed: () {
                    ifCorrectAnswer(listoption1[index].toString());
                  },
                ),
                ElevatedButton(
                  child: Text(listoption2[index].toString()),
                  onPressed: () {
                    ifCorrectAnswer(listoption2[index].toString());
                  },
                ),
                ElevatedButton(
                    child: Text('Suivante'),
                    onPressed: () {
                      incrementindex();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
