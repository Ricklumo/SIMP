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
      version: 3,                    // ← Aumentamos para versão 3
      onCreate: (db, version) async {
        // Tabela de ITENS (já existia)
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

        // NOVA TABELA: USUÁRIOS / INSTRUTORES
        await db.execute('''
          CREATE TABLE usuarios (
            id TEXT PRIMARY KEY,
            nome TEXT NOT NULL,
            matricula TEXT UNIQUE NOT NULL,
            email TEXT,
            telefone TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE usuarios (
              id TEXT PRIMARY KEY,
              nome TEXT NOT NULL,
              matricula TEXT UNIQUE NOT NULL,
              email TEXT,
              telefone TEXT
            )
          ''');
        }
      },
    );
  }
}