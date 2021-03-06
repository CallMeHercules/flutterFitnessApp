import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//local
import 'exercises.dart';

class ExercisesDBConstructor {
  ExercisesDBConstructor._privateConstructor();
  static final ExercisesDBConstructor instance = ExercisesDBConstructor._privateConstructor();

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
    await db.execute('''
      CREATE TABLE IF NOT EXISTS weights(
        id INTEGER PRIMARY KEY
        ,weight INTEGER UNIQUE NOT NULL
        ,quantity INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      insert into weights
      select 1, 45, 6
      union all
      select 2, 25, 2
      union all
      select 3, 10, 2
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercises(
        id INTEGER PRIMARY KEY
        ,barType STRING 
        ,name STRING NOT NULL
      )
    ''');
    await db.execute('''
      insert into exercises
      select 1, 'Barbell', 'Benchpress'
    ''');
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
    await db.execute('''
     insert into exercisePerformed
     select
        1
        ,1
        ,135
        ,10 
        ,datetime('now','localtime')
        union all
        select
        2
        ,1
        ,155
        ,6 
        ,datetime('now','localtime')
        union all
        select
        3
        ,1
        ,185
        ,4
        ,datetime('now','localtime')
        union all
        select
        4
        ,1
        ,225
        ,3
        ,datetime('now','localtime')
        union all
        select
        5
        ,1
        ,245
        ,2 
        ,datetime('now','localtime')
    ''');
    await db.execute('''
    CREATE VIEW v_total_work IF NOT EXISTS
    as
    select sum(id) id
    , exercisesID 
, sum(weight * (1 + 0.0333 * reps)) weight
, sum(reps) reps
    , datetime(t, 'start of day') t
from exercisePerformed
group by datetime(t, 'start of day')
, exercisesID
    ''');
  }

  Future<List<Exercises>> getExercises() async {
    Database db = await instance.database;
    // var exercises = await db.query('exercises');
    var exercises  = await db.rawQuery('''select exercises.*
from exercises
, exercisePerformed
where exercisePerformed.exercisesID = exercises.id
group by exercises.id
order by max(exercisePerformed.t)''');
    List<Exercises> exerciseList = exercises.isNotEmpty
        ? exercises.map((c) => Exercises.fromMap(c)).toList()
        : [];
    return exerciseList;
  }

  Future<String> getName(id) async {
    Database db = await instance.database;
    var exercises = await db.query('exercises'
        , columns: ['name']
        , where: 'id = ?'
        , whereArgs: [id]
    );
    String name ='ERROR';
    for(var i = 0; i < exercises.length; i++){
      var x = exercises[i].values;
      name=x.toString().substring(1,x.toString().length).substring(0,x.toString().length-2);
    }
    return name;
  }

  Future<int> add(Exercises exercises) async {
    Database db = await instance.database;
      return await db.insert('exercises', exercises.toMap());
  }

  Future<int> update(Exercises exercises) async {
    Database db = await instance.database;
    return await db.update('exercises', exercises.toMap(), where: 'id = ?', whereArgs: [exercises.id]);
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }
}