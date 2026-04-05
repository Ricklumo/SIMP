import 'package:flutter/material.dart';
import 'package:simp/database/database_helper.dart';

// ==================== MODELO DE USUÁRIO ====================
class User {
  final String id;
  final String nome;
  final String matricula;
  final String? email;
  final String? telefone;

  User({
    required this.id,
    required this.nome,
    required this.matricula,
    this.email,
    this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'email': email,
      'telefone': telefone,
    };
  }
}

// ==================== MODELO DE ITEM ====================
class Item {
  final String id;
  final String nome;
  final String categoria;
  final int quantidade;
  final DateTime? dataLimite;
  final String solicitante;
  final String observacao;
  final String status;

  Item({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.quantidade,
    this.dataLimite,
    required this.solicitante,
    required this.observacao,
    this.status = 'pendente',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'categoria': categoria,
      'quantidade': quantidade,
      'dataLimite': dataLimite?.toIso8601String(),
      'solicitante': solicitante,
      'observacao': observacao,
      'status': status,
    };
  }
}

// ==================== PROVIDER ====================
class ItemProvider extends ChangeNotifier {
  final List<Item> _itens = [];
  final List<User> _users = [];

  List<Item> get itens => _itens;
  List<User> get users => _users;

  // ==================== MÉTODOS DE ITENS ====================
  Future<void> carregarItens() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('itens');
    _itens.clear();
    for (var map in maps) {
      _itens.add(
        Item(
          id: map['id'] as String,
          nome: map['nome'] as String,
          categoria: map['categoria'] as String,
          quantidade: map['quantidade'] as int,
          dataLimite: map['dataLimite'] != null
              ? DateTime.parse(map['dataLimite'] as String)
              : null,
          solicitante: map['solicitante'] as String,
          observacao: map['observacao'] as String,
          status: map['status'] as String? ?? 'pendente',
        ),
      );
    }
    notifyListeners();
  }

  Future<void> adicionarItem(Item item) async {
    final db = await DatabaseHelper.database;
    await db.insert('itens', item.toMap());
    await carregarItens();
  }

  Future<void> atualizarItem(Item item) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'itens',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    await carregarItens();
  }

  Future<void> atualizarStatus(String id, String novoStatus) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'itens',
      {'status': novoStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
    await carregarItens();
  }

  Future<void> deletarItem(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete('itens', where: 'id = ?', whereArgs: [id]);
    await carregarItens();
  }

  // ==================== MÉTODOS DE USUÁRIOS ====================
  Future<void> carregarUsers() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('usuarios');
    _users.clear();
    for (var map in maps) {
      _users.add(
        User(
          id: map['id'] as String,
          nome: map['nome'] as String,
          matricula: map['matricula'] as String,
          email: map['email'] as String?,
          telefone: map['telefone'] as String?,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> adicionarUser(User user) async {
    final db = await DatabaseHelper.database;
    await db.insert('usuarios', user.toMap());
    await carregarUsers();
  }

  Future<void> deletarUser(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
    await carregarUsers();
  }
}
