import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
      'quantidade': quantidade,
      'dataLimite': dataLimite?.toIso8601String(),
      'solicitante': solicitante,
      'observacao': observacao,
    };
  }

  factory Item.fromMap(String id, Map<String, dynamic> map) {
    return Item(
      id: id,
      nome: map['nome'],
      categoria: map['categoria'],
      quantidade: map['quantidade'],
      dataLimite: map['dataLimite'] != null ? DateTime.parse(map['dataLimite']) : null,
      solicitante: map['solicitante'],
      observacao: map['observacao'],
    );
  }
}

class ItemProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final List<Item> _itens = [];

  List<Item> get itens => _itens;

  Future<void> carregarItens() async {
    final snapshot = await _db.collection('itens').get();
    _itens.clear();
    for (var doc in snapshot.docs) {
      _itens.add(Item.fromMap(doc.id, doc.data()));
    }
    notifyListeners();
    _verificarAtrasos(); // ← verifica atrasos toda vez que carrega
  }

  Future<void> adicionarItem(Item item) async {
    final docRef = await _db.collection('itens').add(item.toMap());
    final novoItem = Item(
      id: docRef.id,
      nome: item.nome,
      categoria: item.categoria,
      quantidade: item.quantidade,
      dataLimite: item.dataLimite,
      solicitante: item.solicitante,
      observacao: item.observacao,
    );
    _itens.add(novoItem);
    notifyListeners();
    _verificarAtrasos();
  }

  void _verificarAtrasos() {
    final hoje = DateTime.now();
    final atrasados = _itens.where((item) =>
    item.dataLimite != null && item.dataLimite!.isBefore(hoje)).length;

    if (atrasados > 0) {
      print('⚠️ ALERTA: $atrasados itens estão ATRASADOS!');
      // Mostra alerta global (vai aparecer em qualquer tela)
      // Você pode chamar isso de qualquer tela com Provider.of<ItemProvider>(context).verificarAtrasos();
    }
  }
}