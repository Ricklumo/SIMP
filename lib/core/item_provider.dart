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

  Item({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.quantidade,
    this.dataLimite,
    required this.solicitante,
    required this.observacao,
  });
}

class ItemProvider extends ChangeNotifier {
  final List<Item> _itens = [];

  List<Item> get itens => _itens;

  /// Carrega todos os itens do SQLite
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
        dataLimite: map['dataLimite'] != null
            ? DateTime.parse(map['dataLimite'] as String)
            : null,
        solicitante: map['solicitante'] as String,
        observacao: map['observacao'] as String,
      ));
    }
    notifyListeners();
  }

  /// Adiciona item e recarrega tudo do banco (garantia de atualização)
  Future<void> adicionarItem(Item item) async {
    final db = await DatabaseHelper.database;

    await db.insert('itens', {
      'id': item.id,
      'nome': item.nome,
      'categoria': item.categoria,
      'quantidade': item.quantidade,
      'dataLimite': item.dataLimite?.toIso8601String(),
      'solicitante': item.solicitante,
      'observacao': item.observacao,
    });

    // Recarrega tudo do banco para garantir que todas as telas atualizem
    await carregarItens();
  }
}