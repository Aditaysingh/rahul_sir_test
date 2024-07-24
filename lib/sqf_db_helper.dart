import 'dart:async';
import 'package:path/path.dart';
import 'package:rahul_sir_test/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final String noteTable = "notes";
  static final int _version = 1;
  static final String columnId = "id";
  static final String columnTitle = "title";
  static final String columnDescription = "description";
  static final String columnImage = "image";

  Future<Database> get database async {
    final dir = await getDatabasesPath();
    String path = join(dir, 'notesDb.db');
    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $noteTable(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT,
        $columnImage TEXT
      )
    ''');
  }

  Future<void> addNote(UserModel userModel) async {
    final db = await database;
    try {
      await db.insert(noteTable, userModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e);
    }
  }

  Future<List<UserModel>> getAllData() async {
    final db = await database;
    var data = await db.query(noteTable);
    List<UserModel> notes = [];
    if (data.isNotEmpty) {
      for (var i in data) {
        notes.add(UserModel.fromMap(i));
      }
    }
    return notes;
  }

  Future<void> updateData(UserModel notesModel) async {
    final db = await database;
    await db.update(noteTable, notesModel.toMap(),
        where: '$columnId = ?', whereArgs: [notesModel.id]);
  }

  Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete(noteTable, where: '$columnId = ?', whereArgs: [id]);
  }
}
