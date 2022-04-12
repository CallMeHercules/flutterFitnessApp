import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//local
import 'weights.dart';

class WeightsDBConstructor {
  WeightsDBConstructor._privateConstructor();
  static final WeightsDBConstructor instance = WeightsDBConstructor._privateConstructor();

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
    ''');
  }

  Future<List<Weights>> getWeights() async {
    Database db = await instance.database;
    var weights = await db.query('weights');
    List<Weights> weightsList = weights.isNotEmpty
        ? weights.map((c) => Weights.fromMap(c)).toList()
        : [];
    return weightsList;
  }

  Future<int> add(Weights weights) async {
    Database db = await instance.database;
    return await db.insert('weights', weights.toMap());
  }

  Future<int> update(Weights weights) async {
    Database db = await instance.database;
    return await db.update('weights', weights.toMap(), where: 'id = ?', whereArgs: [weights.id]);
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('weights', where: 'id = ?', whereArgs: [id]);
  }
}