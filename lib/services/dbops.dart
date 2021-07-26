import 'package:my_notes/models/note.dart';
import 'package:my_notes/models/ops.dart';
import 'package:my_notes/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

Future<Database> getdb() async{
  return openDatabase(
    join(await getDatabasesPath(), 'testalpha_database.db'),
    onCreate: (db, version) async{
      await db.execute(
        "CREATE TABLE notes (id TEXT PRIMARY KEY, title TEXT, body TEXT, userid TEXT)",
      );
      await db.execute(
        "CREATE TABLE cusers (id TEXT PRIMARY KEY, email TEXT)",
      );
      await db.execute(
        "CREATE TABLE pendingops (id TEXT PRIMARY KEY, noteid TEXT, title TEXT, body TEXT, userid TEXT, operation TEXT)",
      );
    },
    version: 2,
  );
}

class DBHelper {
  final Future<Database> database = getdb();

  Future<void> insertNote(Note note) async {
    final Database db = await database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    Map<String, dynamic> opmap = Operation(id: Uuid().v4(), noteid: note.id, userid: note.userid, body: note.body, title: note.title, operation: 'INSERT').toMap();
    await db.insert(
      'pendingops',
      opmap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(Note note) async {
    final Database db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id]
    );
    Map<String, dynamic> opmap = Operation(id: Uuid().v4(), noteid: note.id, userid: note.userid, body: note.body, title: note.title, operation: 'UPDATE').toMap();
    await db.insert(
      'pendingops',
      opmap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNote(Note note) async {
    final Database db = await database;
    await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [note.id]
    );
    Map<String, dynamic> opmap = Operation(id: Uuid().v4(), noteid: note.id, userid: note.userid, body: note.body, title: note.title, operation: 'DELETE').toMap();
    await db.insert(
      'pendingops',
      opmap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> userLogged(CUser user) async {
    final Database db = await database;

    await db.insert(
      'cusers',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> logOutUser() async {
    final Database db = await database;
    await db.delete('cusers');
  }

  Future<void> clearOps() async {
    final Database db = await database;
    await db.delete('pendingops');
  }

  Future<List<Note>> getNotes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
        userid: maps[i]['userid'],
      );
    });
  }

  Future<List<Operation>> pendingOps() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pendingops');

    return List.generate(maps.length, (i) {
      return Operation(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
        userid: maps[i]['userid'],
        operation: maps[i]['operation'],
        noteid: maps[i]['noteid']
      );
    });
  }


  Future<List<CUser>> getUser() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cusers');

    return List.generate(maps.length, (i) {
      return CUser(
          id: maps[i]['id'],
          email: maps[i]['email']
      );
    });
  }

}