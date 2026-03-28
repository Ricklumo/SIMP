import 'package:flutter/material.dart';
import 'package:simp/database/database_helper.dart';

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

class ItemProvider extends ChangeNotifier {
  final List<Item> _itens = [];

  List<Item> get itens => _itens;

  Future<void> carregarItens() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('itens');

    _itens.clear();
    for (var map in maps) {
      _itens.add(Item(
        id: map['id'] as String,
        nome: map['nome'] as String,
        categoria: map['categoria'] as String,
        quantidade: map['quantidade'] as int,
        dataLimite: map['dataLimite'] != null ? DateTime.parse(map['dataLimite'] as String) : null,
        solicitante: map['solicitante'] as String,
        observacao: map['observacao'] as String,
        status: map['status'] as String? ?? 'pendente',
      ));
    }
    notifyListeners();
  }

  Future<void> adicionarItem(Item item) async {
    final db = await DatabaseHelper.database;
    await db.insert('itens', item.toMap());
    await carregarItens();
  }

  // Novo: Atualiza um item completo (usado no editar)
  Future<void> atualizarItem(Item item) async {
    final db = await DatabaseHelper.database;
    await db.update('itens', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    await carregarItens();
  }

  // Novo: Muda o status (concluído / pendente)
  Future<void> atualizarStatus(String id, String novoStatus) async {
    final db = await DatabaseHelper.database;
    await db.update('itens', {'status': novoStatus}, where: 'id = ?', whereArgs: [id]);
    await carregarItens();
  }

  // Novo: Exclui um item
  Future<void> deletarItem(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete('itens', where: 'id = ?', whereArgs: [id]);
    await carregarItens();
  }
}