import 'package:flutter/material.dart';
import 'package:note_book_flutter_app/localization/demo_localization.dart';
import 'package:note_book_flutter_app/modules/note.dart';

import 'note_details.dart';

class SearchItem extends SearchDelegate<Note> {
  List<Note> noteList;
  SearchItem(this.noteList);
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.black,
      backgroundColor: Colors.black87,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.blue),
      primaryColorBrightness: Brightness.dark,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty
        ? noteList
        : noteList
            .where((element) =>
                element.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return myList.isEmpty
        ? Text("Not Found!!!!!")
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (BuildContext context, int index) {
              final note = myList[index];
              return ListTile(
                title: Text(note.noteTitle),
                onTap: () {
                  navigateToNoteDetail(
                      myList[index],
                      DemoLocalizations.of(context)
                          .getTranslatedValue("editNote"),
                      context);
                },
              );
            },
          );
  }

  void navigateToNoteDetail(
      Note note, String title, BuildContext context) async {
    var res =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(note, title);
    }));
  }
}
