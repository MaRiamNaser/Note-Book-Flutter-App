import 'package:flutter/material.dart';
import 'package:note_book_flutter_app/modules/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singletone!
  static Database _database; //Singletone

  String table = 'MyNoteTable';
  String idCol = 'Id';
  String titleCol = 'Title';
  String descriptionCol = 'Description';
  String priorityCol = 'Priority';
  String dateCol = 'Date';
  String colorCol = 'Color';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  void _createDb(Database db, int ver) async {
    await db.execute(
        'CREATE TABLE $table($idCol INTEGER PRIMARY KEY AUTOINCREMENT, $titleCol TEXT, '
        '$descriptionCol TEXT, $priorityCol INTEGER, $dateCol TEXT, $colorCol TEXT)');
  }

  Future<Database> initializeDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    //String databasesPath = await getDatabasesPath();
    //String dbPath = join(databasesPath, 'my.db');
    String path = directory.path + 'notes.db';

    //debugPrint(path);
    var dpNote = await openDatabase(path, version: 1, onCreate: _createDb);
    return dpNote;
  }

  Future<Database> getDatabase() async {
    if (_database == null) {
      _database = await initializeDataBase();
    }
    return _database;
  }

  //Get all notes from database
  Future<List<Map<String, dynamic>>> getListNoteOfMaps() async {
    Database db = await this.getDatabase();

    //var notes = await db.rawQuery('SELECT * FROM $Table order by $PriorityCol ASC');
    var notes = await db.query(table, orderBy: '$priorityCol ASC');
//    for (int i = 0; i < notes.length; ++i) {
//      debugPrint(notes[i].toString());
//    }
    return notes;
  }

  //Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.getDatabase();
    var numberOfRowsInserted = await db.insert(table, note.toMap());

    //  debugPrint("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    //  debugPrint(note.toMap().toString());
    return numberOfRowsInserted;
  }

  //Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.getDatabase();
    var numberOfRowsUpdated = await db.update(table, note.toMap(),
        where: '$idCol = ?', whereArgs: [note.noteId]);
    return numberOfRowsUpdated;
  }

  //Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.getDatabase();
    int numberOfRowsDeleted =
        await db.rawDelete('DELETE FROM $table WHERE $idCol = $id');
    return numberOfRowsDeleted;
  }

  //Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.getDatabase();
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {
    // debugPrint("########################################################");
    var noteMapList = await getListNoteOfMaps(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      debugPrint(Note.fromMapObject(noteMapList[i]).toString());
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    for (int i = 0; i < noteList.length; ++i) {
      debugPrint(noteList[i].toString());
    }
    return noteList;
  }
}
