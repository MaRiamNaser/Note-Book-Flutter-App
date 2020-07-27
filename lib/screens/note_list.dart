import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_book_flutter_app/database/helper.dart';
import 'package:note_book_flutter_app/dialog/confirmation_dialog.dart';
import 'package:note_book_flutter_app/localization/demo_localization.dart';
import 'package:note_book_flutter_app/modules/language.dart';
import 'package:note_book_flutter_app/modules/note.dart';
import 'package:note_book_flutter_app/screens/search.dart';

import 'package:sqflite/sqflite.dart';

import '../my_app.dart';
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
  List<Note> _notesForDisplay;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _notesForDisplay = noteList;
    // count = _notesForDisplay.length;
  }

  TextStyle txtStyleVerySmall;
  TextStyle txtStyleBig;
  TextStyle txtStyle;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      _notesForDisplay = List<Note>();
      updateListView();
    }

    txtStyleBig = TextStyle(
      fontFamily: 'Chewy',
      fontSize: 35.0,
    );
    txtStyle = TextStyle(
      fontFamily: 'Chewy',
      fontSize: 20.0,
    );

    txtStyleVerySmall = TextStyle(
      fontFamily: 'Chewy',
      fontSize: 12.0,
    );

    var padding2 = Padding(
      padding: EdgeInsets.all(15.0),
      child: createGenericListView(count, txtStyle),
    );
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
                    gradient: LinearGradient(colors: <Color>[
                  Color.fromRGBO(27, 38, 44, 1),
                  Color.fromRGBO(15, 76, 117, 1),
                  Color.fromRGBO(50, 130, 184, 1),
                  Color.fromRGBO(53, 156, 224, 1),
                ])),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  DemoLocalizations.of(context).getTranslatedValue("about"),
                  style: txtStyle,
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  DemoLocalizations.of(context).getTranslatedValue("settings"),
                  style: txtStyle,
                ),
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
        // backgroundColor: Color.fromRGBO(50, 130, 184, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(15, 76, 117, 1),
          // leading: Icon(Icons.menu),
          title: Text(
            DemoLocalizations.of(context).getTranslatedValue("title"),
            style: txtStyleBig,
          ),

          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8),
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
                                  //fontFamily: 'Chewy',
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                lang.name,
                                style: txtStyle,
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
            Padding(
              padding: EdgeInsets.only(top: 8, right: 18),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  await showSearch(
                    context: context,
                    delegate: SearchItem(noteList),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: createFloatingActionButton(),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            // Color.fromRGBO(187, 225, 250, 1),
            //Color.fromRGBO(146, 207, 244, 1),
            Color.fromRGBO(27, 38, 44, 1),
            Color.fromRGBO(15, 76, 117, 1),
            Color.fromRGBO(50, 130, 184, 1),
            Color.fromRGBO(53, 156, 224, 1),
          ])),
          child: padding2,
        ));
  }

  Widget createGenericListView(int count, TextStyle txtStyle) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int position) {
        return position == 0
            ? _searchBar()
            : _listItem(position - 1, count, txtStyle);
      },
      itemCount: _notesForDisplay.length + 1,
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: txtStyle,
              decoration: InputDecoration(
                hintText: 'Search....',
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  _notesForDisplay = noteList.where((note) {
                    var noteTitle = note.title.toLowerCase();
                    return noteTitle.contains(text);
                  }).toList();
                });
              },
            ),
          ),
          Icon(Icons.search),
        ],
      ),
    );
  }

  _listItem(position, int count, TextStyle txtStyle) {
    var card = Card(
      color: getColorOfCard(this.noteList[position].noteColor),
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getPriorityColor(this.noteList[position].priority),
          child: getPriorityIcon(this._notesForDisplay[position].priority),
        ),
        title: Text(
          _notesForDisplay[position].noteTitle,
          style: txtStyle,
        ),
        subtitle: Text(
          _notesForDisplay[position].noteDate,
          style: txtStyleVerySmall,
        ),
        trailing: GestureDetector(
          child: Icon(
            Icons.delete,
            color: Colors.white70,
          ),
          onTap: () {
            var res = showDialog(
                context: context,
                builder: (context) => ExitConfirmationDialog());

            setState(() {
              res.then((value) {
                if (value == true) {
                  _delete(context, noteList[position]);
                  //_delete(context, _notesForDisplay[position]);
                }
              });
            });
          },
        ),
        onTap: () {
          navigateToNoteDetail(noteList[position],
              DemoLocalizations.of(context).getTranslatedValue("editNote"));
        },
      ),
    );
    return card;
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
        return Icon(Icons.priority_high);
        break;
      case 2:
        return Icon(Icons.low_priority);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  Widget createFloatingActionButton() {
    return FloatingActionButton(
      tooltip: DemoLocalizations.of(context).getTranslatedValue("tooltipAdd"),
      backgroundColor: Colors.white,
      onPressed: () {
        navigateToNoteDetail(
          Note('', '', 2),
          DemoLocalizations.of(context).getTranslatedValue("addNote"),
        );
      },
      child: Icon(
        Icons.note_add,
        color: Colors.pinkAccent,
      ),
    );
  }

  void changeLanguage(Language language) {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, "US");
        break;
      case 'ar':
        _temp = Locale(language.languageCode, "EG");
        break;
      default:
        _temp = Locale(language.languageCode, "US");
    }

    MyApp.setLocale(context, _temp);
  }

  Color getColorOfCard(String color) {
    if (color == "Green") {
      return Colors.green;
    } else if (color == "Yellow") {
      return Colors.orange;
    } else if (color == "Pink") {
      return Colors.pink;
    } else if (color == "Grey") {
      return Colors.blue;
    } else {
      return Colors.blue;
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
          //this.count = noteList.length;
          this._notesForDisplay = noteList;
          // this.count = _notesForDisplay.length;
        });
      });
    });

    // this._notesForDisplay = noteList;
    //this.count = _notesForDisplay.length;
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.noteId);
    if (result != 0) {
      showSnackBar(
          context,
          DemoLocalizations.of(context)
              .getTranslatedValue("noteDeletedSuccessfully"));
      // _notesForDisplay = noteList;
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

/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_book_flutter_app/database/helper.dart';
import 'package:note_book_flutter_app/dialog/confirmation_dialog.dart';
import 'package:note_book_flutter_app/localization/demo_localization.dart';
import 'package:note_book_flutter_app/modules/language.dart';
import 'package:note_book_flutter_app/modules/note.dart';

import 'package:sqflite/sqflite.dart';

import '../my_app.dart';
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
  List<Note> _notesForDisplay;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _notesForDisplay = noteList;
    // count = _notesForDisplay.length;
  }

  TextStyle txtStyleVerySmall;
  TextStyle txtStyleBig;
  TextStyle txtStyle;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      _notesForDisplay = List<Note>();
      updateListView();
    }

    txtStyleBig = TextStyle(
      fontFamily: 'Chewy',
      fontSize: 35.0,
    );
    txtStyle = TextStyle(
      fontFamily: 'Chewy',
      fontSize: 20.0,
    );

    txtStyleVerySmall = TextStyle(
      fontFamily: 'Chewy',
      fontSize: 12.0,
    );

    var padding2 = Padding(
      padding: EdgeInsets.all(15.0),
      child: createGenericListView(count, txtStyle),
    );
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
                    gradient: LinearGradient(colors: <Color>[
                  Color.fromRGBO(27, 38, 44, 1),
                  Color.fromRGBO(15, 76, 117, 1),
                  Color.fromRGBO(50, 130, 184, 1),
                  Color.fromRGBO(53, 156, 224, 1),
                ])),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  DemoLocalizations.of(context).getTranslatedValue("about"),
                  style: txtStyle,
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  DemoLocalizations.of(context).getTranslatedValue("settings"),
                  style: txtStyle,
                ),
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
        // backgroundColor: Color.fromRGBO(50, 130, 184, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(15, 76, 117, 1),
          // leading: Icon(Icons.menu),
          title: Text(
            DemoLocalizations.of(context).getTranslatedValue("title"),
            style: txtStyleBig,
          ),

          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 18, left: 18),
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
                                  //fontFamily: 'Chewy',
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                lang.name,
                                style: txtStyle,
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
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            // Color.fromRGBO(187, 225, 250, 1),
            //Color.fromRGBO(146, 207, 244, 1),
            Color.fromRGBO(27, 38, 44, 1),
            Color.fromRGBO(15, 76, 117, 1),
            Color.fromRGBO(50, 130, 184, 1),
            Color.fromRGBO(53, 156, 224, 1),
          ])),
          child: padding2,
        ));
  }

  Widget createGenericListView(int count, TextStyle txtStyle) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int position) {
        return position == 0
            ? _searchBar()
            : _listItem(position - 1, count, txtStyle);
      },
      itemCount: _notesForDisplay.length + 1,
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: txtStyle,
              decoration: InputDecoration(
                hintText: 'Search....',
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  _notesForDisplay = noteList.where((note) {
                    var noteTitle = note.title.toLowerCase();
                    return noteTitle.contains(text);
                  }).toList();
                });
              },
            ),
          ),
          Icon(Icons.search),
        ],
      ),
    );
  }

  _listItem(position, int count, TextStyle txtStyle) {
    var card = Card(
      color: getColorOfCard(this.noteList[position].noteColor),
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getPriorityColor(this.noteList[position].priority),
          child: getPriorityIcon(this._notesForDisplay[position].priority),
        ),
        title: Text(
          _notesForDisplay[position].noteTitle,
          style: txtStyle,
        ),
        subtitle: Text(
          _notesForDisplay[position].noteDate,
          style: txtStyleVerySmall,
        ),
        trailing: GestureDetector(
          child: Icon(
            Icons.delete,
            color: Colors.white70,
          ),
          onTap: () {
            var res = showDialog(
                context: context,
                builder: (context) => ExitConfirmationDialog());

            setState(() {
              res.then((value) {
                if (value == true) {
                  _delete(context, noteList[position]);
                  //_delete(context, _notesForDisplay[position]);
                }
              });
            });
          },
        ),
        onTap: () {
          navigateToNoteDetail(noteList[position],
              DemoLocalizations.of(context).getTranslatedValue("editNote"));
        },
      ),
    );
    return card;
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
        return Icon(Icons.priority_high);
        break;
      case 2:
        return Icon(Icons.low_priority);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  Widget createFloatingActionButton() {
    return FloatingActionButton(
      tooltip: DemoLocalizations.of(context).getTranslatedValue("tooltipAdd"),
      backgroundColor: Colors.white,
      onPressed: () {
        navigateToNoteDetail(
          Note('', '', 2),
          DemoLocalizations.of(context).getTranslatedValue("addNote"),
        );
      },
      child: Icon(
        Icons.note_add,
        color: Colors.pinkAccent,
      ),
    );
  }

  void changeLanguage(Language language) {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, "US");
        break;
      case 'ar':
        _temp = Locale(language.languageCode, "EG");
        break;
      default:
        _temp = Locale(language.languageCode, "US");
    }

    MyApp.setLocale(context, _temp);
  }

  Color getColorOfCard(String color) {
    if (color == "Green") {
      return Colors.green;
    } else if (color == "Yellow") {
      return Colors.orange;
    } else if (color == "Pink") {
      return Colors.pink;
    } else if (color == "Grey") {
      return Colors.blue;
    } else {
      return Colors.blue;
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
          //this.count = noteList.length;
          this._notesForDisplay = noteList;
          // this.count = _notesForDisplay.length;
        });
      });
    });

    // this._notesForDisplay = noteList;
    //this.count = _notesForDisplay.length;
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.noteId);
    if (result != 0) {
      showSnackBar(
          context,
          DemoLocalizations.of(context)
              .getTranslatedValue("noteDeletedSuccessfully"));
      // _notesForDisplay = noteList;
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


 */
