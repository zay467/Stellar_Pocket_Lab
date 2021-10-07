import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AccountDatabase {
  static final _dbName = 'stellarPocketLab.db';
  static final _dbVersion = 1;
  static final testnetTable = 'testnet';
  static final mainnetTable = 'mainnet';
  static final idNum = "_id";
  static final publicKey = "publicKey";
  static final privateKey = "privateKey";
  static final username = "username";
  static final password = "password";

  AccountDatabase._privateConstructor();
  static final AccountDatabase instance = AccountDatabase._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $mainnetTable (
    $idNum INTEGER PRIMARY KEY,
    $privateKey TEXT NOT NULL,
    $publicKey TEXT NOT NULL,
    $username TEXT NOT NULL,
    $password TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE $testnetTable (
    $idNum INTEGER PRIMARY KEY,
    $privateKey TEXT NOT NULL,
    $publicKey TEXT NOT NULL,
    $username TEXT NOT NULL,
    $password TEXT NOT NULL
    )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row, String _tableName) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future update(Map<String, dynamic> row, String _tableName) async {
    Database db = await instance.database;
    int id = row[idNum];
    return await db.update(_tableName, row, where: '$idNum=?', whereArgs: [id]);
  }

  Future<int> delete(int id, String _tableName) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$idNum=?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> read(String _tableName) async {
    Database db = await instance.database;
    return await db.query(_tableName, orderBy: idNum);
  }
}
