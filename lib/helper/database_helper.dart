import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'search_history.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, query TEXT)',
        );


        db.execute(
          'CREATE TABLE bookmarks(id INTEGER PRIMARY KEY AUTOINCREMENT, query TEXT, url TEXT)',
        );
      },
    );
  }

  Future<void> insertHistory(String query) async {
    final db = await database;
    await db.insert(
      'history',
      {'query': query},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('history');

    return List.generate(maps.length, (i) {
      return maps[i]['query'] as String;
    });
  }

  Future<void> deleteHistory(String query) async {
    final db = await database;
    await db.delete(
      'history',
      where: 'query = ?',
      whereArgs: [query],
    );
  }

  Future<void> insertBookmark(String query, String url) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      {
        'query': query,
        'url': url,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, String>>> getBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');

    return List.generate(maps.length, (i) {
      return {
        'query': maps[i]['query'] as String,
        'url': maps[i]['url'] as String,
      };
    });
  }

  Future<void> deleteBookmark(String url) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'url = ?',
      whereArgs: [url],
    );
  }
}
