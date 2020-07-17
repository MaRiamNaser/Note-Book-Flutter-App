import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_book_flutter_app/database/helper.dart';
import 'package:note_book_flutter_app/dialog/confirmation_dialog.dart';
import 'package:note_book_flutter_app/modules/language.dart';
import 'package:note_book_flutter_app/modules/note.dart';

import 'package:sqflite/sqflite.dart';

import 'note_details.dart';

class NoteList extends StatefulWidget {
  @override
  NoteListState createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  //_MySearchDelegate _delegate;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    TextStyle txtStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'images/notebook2.png',
                    height: 300,
                    width: 300,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.pink,
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          // leading: Icon(Icons.menu),
          title: Text("App Notes"),

          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 18, left: 1),
              child: DropdownButton(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                // onTap: () {},

                items: Language.languageList()
                    .map<DropdownMenuItem>((lang) => DropdownMenuItem<Language>(
                          value: lang,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                lang.flag,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                lang.name,
                              ),
                            ],
                          ),
                        ))
                    .toList(),

                onChanged: (var newlang) {
                  changeLanguage(newlang);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: createFloatingActionButton(),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: createGenericListView(count, txtStyle),
        ));
  }

  Widget createGenericListView(int count, TextStyle txtStyle) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: getColorOfCard(this.noteList[position].noteColor),
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(
              noteList[position].noteTitle,
              style: txtStyle,
            ),
            subtitle: Text(noteList[position].noteDate),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                var res = showDialog(
                    context: context,
                    builder: (context) => ExitConfirmationDialog());

                setState(() {
                  res.then((value) {
                    if (value == true) {
                      _delete(context, noteList[position]);
                    }
                  });
                });
              },
            ),
            onTap: () {
              navigateToNoteDetail(noteList[position], "Edit Note!");
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  Widget createFloatingActionButton() {
    return FloatingActionButton(
      tooltip: "Add Note",
      backgroundColor: Colors.white,
      onPressed: () {
        navigateToNoteDetail(Note('', '', 2), "Add Note!");
      },
      child: Icon(
        Icons.note_add,
        color: Colors.pinkAccent,
      ),
    );
  }

  void changeLanguage(Language language) {
    debugPrint("###");
  }

  Color getColorOfCard(String color) {
    if (color == "Green") {
      return Colors.lightGreen;
    } else if (color == "Yellow") {
      return Colors.deepOrange;
    } else if (color == "Pink") {
      return Colors.pink;
    } else if (color == "Grey") {
      return Colors.grey;
    }
  }

  void navigateToNoteDetail(Note note, String title) async {
    var res =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(note, title);
    }));

    if (res == true) {
      setState(() {
        updateListView();
      });
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDataBase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.noteId);
    if (result != 0) {
      showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
