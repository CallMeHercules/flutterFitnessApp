import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//local
import 'exercisePerformed.dart';

class ExercisePerformedDBConstructor {
  ExercisePerformedDBConstructor._privateConstructor();
  static final ExercisePerformedDBConstructor instance = ExercisePerformedDBConstructor._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, 'flutterFitnessApp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {

    db.execute('''PRAGMA foreign_keys = ON''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercisePerformed(
        id INTEGER PRIMARY KEY
        ,exercisesID INTEGER 
        ,weight INTEGER NOT NULL
        ,reps INTEGER NOT NULL
        ,t TIMESTAMP
  DEFAULT CURRENT_TIMESTAMP
        ,FOREIGN KEY(exercisesID) REFERENCES exercises(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<List<ExercisePerformed>> getExercisePerformed(int id) async {
    Database db = await instance.database;
    var exercisePerformed = await db.query('exercisePerformed', where: 'exercisesID = ?', whereArgs: [id], orderBy: '''datetime(t,'start of day') desc, id''');
    List<ExercisePerformed> exercisePerformedList = exercisePerformed.isNotEmpty
        ? exercisePerformed.map((c) => ExercisePerformed.fromMap(c)).toList()
        : [];
    return exercisePerformedList;
  }

  Future<List<ExercisePerformed>> getExercisePerformedToday(int id, String swap) async {
    Database db = await instance.database;
    
    switch (swap)
    {
      case 'TODAY': {
        var exercisePerformed = await db.query('exercisePerformed',where: '''datetime(t,'start of day') == datetime(DATE('now','localtime'), 'start of day') AND exercisesID = ?''',whereArgs: [id], orderBy: 't');
        List<ExercisePerformed> exercisePerformedList = exercisePerformed
            .isNotEmpty
            ? exercisePerformed.map((c) => ExercisePerformed.fromMap(c)).toList()
            : [];
        return exercisePerformedList;
      }

      case 'TOTAL WORK PERFORMED OVER TIME': {
        // var exercisePerformed  = await db.rawQuery();
        var exercisePerformed = await db.query('v_total_work',where: 'exercisesID = ?',whereArgs: [id], orderBy: 't');
        List<ExercisePerformed> exercisePerformedList = exercisePerformed
            .isNotEmpty
            ? exercisePerformed.map((c) => ExercisePerformed.fromMap(c)).toList()
            : [];
        return exercisePerformedList;
      }

    }
    var exercisePerformed = await db.query('exercisePerformed',where: 'exercisesID = ?',whereArgs: [id], orderBy: 't');
    List<ExercisePerformed> exercisePerformedList = exercisePerformed
        .isNotEmpty
        ? exercisePerformed.map((c) => ExercisePerformed.fromMap(c)).toList()
        : [];
    return exercisePerformedList;
  }

  Future<int> add(ExercisePerformed exercisePerformed) async {
    Database db = await instance.database;
    db.execute('''PRAGMA foreign_keys = ON''');
    return await db.insert('exercisePerformed', exercisePerformed.toMap());

  }

  Future<int> update(ExercisePerformed exercisePerformed) async {
    Database db = await instance.database;
    return await db.update('exercisePerformed', exercisePerformed.toMap(), where: 'id = ?', whereArgs: [exercisePerformed.id]);
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('exercisePerformed', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> getName(int id) async {
    Database db = await instance.database;
    return await db.query(
        'exercises',
        columns: ['name'],
        where: 'id = ?',
        whereArgs: [id]);
  }
}