
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path;

    if (kIsWeb) {
      path = 'products.db';
    } else {
      String databasePath = await getDatabasesPath();
      path = join(databasePath, 'products.db');
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            quantity INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  static Future<int> insertProduct(
      Map<String, dynamic> product) async {
    Database db = await database;
    return await db.insert('products', product);
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    Database db = await database;
    return await db.query('products');
  }
}
