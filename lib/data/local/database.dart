import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class NeptunDatabase {
  static NeptunDatabase? _instance;
  NeptunDatabase._();

  static Database? _database;

  factory NeptunDatabase() {
    WidgetsFlutterBinding.ensureInitialized();
    return _instance ??= NeptunDatabase._();
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _init();
      return _database!;
    }
  }

  Future<Database> _init() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    return await openDatabase(
      join(await getDatabasesPath(), "neptun_database.db"),
      onCreate: (db, version) async {
        await db.execute("""
            CREATE TABLE events(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              startDate INTEGER,
              endDate INTEGER, 
              title TEXT, 
              location TEXT)""");
        await db.execute("""
            CREATE TABLE messages(
              id INTEGER PRIMARY KEY,
              title TEXT,
              sender TEXT,
              date INTEGER,
              body TEXT)""");
        await db.execute("""
            CREATE TABLE personals(
              neptunCode TEXT PRIMARY KEY,
              preName TEXT,
              firstName TEXT,
              lastName TEXT,
              fullName TEXT,
              birthDate INTEGER,
              birthCountry TEXT,
              birthCounty TEXT,
              birthPlace TEXT,
              gender TEXT,
              eduId TEXT,
              mothersName TEXT,
              tajNumber INTEGER,
              taxNumber INTEGER,
              omNumber INTEGER,
              examId TEXT)""");
        await db.execute("""
          CREATE TABLE credentials(
            id INTEGER PRIMARY KEY,
            username TEXT,
            password TEXT,
            hash TEXT)""");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute("""
          CREATE TABLE credentials(
            id INTEGER PRIMARY KEY,
            username TEXT,
            password TEXT,
            hash TEXT)""");
      },
      version: 9,
    );
  }
}
