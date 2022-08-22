import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final albumtable = 'album';
  static final albumartstable = 'albumarts';

  static final columnId = '_id';
  static final columnalbumtitle = 'title';
  static final columnalbumid = 'albumid';

  static final columnartId = '_id';
  static final columnimgurl = 'imageurl';
  static final columnartalbumid = 'albumid';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $albumtable ($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnalbumtitle TEXT NOT NULL, $columnalbumid TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE $albumartstable ($columnartId INTEGER PRIMARY KEY AUTOINCREMENT, $columnimgurl TEXT NOT NULL, $columnartalbumid TEXT NOT NULL)');
  }

  Future<int> insert(Map<String, dynamic> row, tablename) async {
    Database db = await instance.database;
    return await db.insert(tablename, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(tablename) async {
    Database db = await instance.database;
    return await db.query(tablename);
  }
}
