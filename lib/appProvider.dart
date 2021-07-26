import 'package:flutter/material.dart';
import 'package:my_notes/models/note.dart';
import 'package:my_notes/models/user.dart';
import 'package:uuid/uuid.dart';

class AppProvider extends ChangeNotifier {
  List<Note> notes = [];
  CUser user;
  String title = '';
  String body = '';

  void addNote(String title, String body) {
    var uniqId = Uuid().v4();
    notes.add(Note(title: title, body: body, id: uniqId, userid: user.email));
    notifyListeners();
  }

  void updateNote(String id, String title, String body) {
    int index = notes.indexWhere((element) => element.id == id);
    notes[index].title = title;
    notes[index].body = body;
    notifyListeners();
  }

  void deleteNote(String id) {
    notes.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateAppData(notesdata) {
    notes = notesdata;
    notifyListeners();
  }
}
