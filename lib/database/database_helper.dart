import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'simp.db');

    return await openDatabase(
      path,
      version: 2, // ← aumentamos a versão
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE itens (
            id TEXT PRIMARY KEY,
            nome TEXT,
            categoria TEXT,
            quantidade INTEGER,
            dataLimite TEXT,
            solicitante TEXT,
            observacao TEXT,
            status TEXT DEFAULT 'pendente'
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE itens ADD COLUMN status TEXT DEFAULT "pendente"',
          );
        }
      },
    );
  }
}
