class Note {
  int noteId;
  String noteTitle;
  String noteDescription;
  String noteDate;
  int notePriority;
  String noteColor;

  Note(this.noteTitle, this.noteDate, this.notePriority,
      [this.noteDescription]);

  Note.withId(this.noteId, this.noteTitle, this.noteDate, this.notePriority,
      [this.noteDescription]);

  int get id => noteId;

  String get title => noteTitle;

  String get description => noteDescription;

  int get priority => notePriority;

  String get date => noteDate;

  String get color => noteColor;

  @override
  String toString() {
    return 'Note{noteId: $noteId, noteTitle: $noteTitle, noteDescription: $noteDescription, noteDate: $noteDate, notePriority: $notePriority}';
  }

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this.noteTitle = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this.noteDescription = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this.notePriority = newPriority;
    }
  }

  set color(String newColor) {
    this.noteColor = newColor;
  }

  set date(String newDate) {
    this.noteDate = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = noteId;
    }
    map['title'] = noteTitle;
    map['description'] = noteDescription;
    map['priority'] = notePriority;
    map['date'] = noteDate;
    map['color'] = noteColor;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this.noteId = map['Id'];
    this.noteTitle = map['Title'];
    this.noteDescription = map['Description'];
    this.notePriority = map['Priority'];
    this.noteDate = map['Date'];
    this.noteColor = map['Color'];
  }
}
