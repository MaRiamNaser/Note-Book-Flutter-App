import 'package:flutter/material.dart';
import 'package:note_book_flutter_app/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteBook",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan, brightness: Brightness.dark),
      home: NoteList(),
    );
  }
}
