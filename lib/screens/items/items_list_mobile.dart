import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class ItemsListMobile extends StatefulWidget {
  const ItemsListMobile({super.key});

  @override
  State<ItemsListMobile> createState() => _ItemsListMobileState();
}

class _ItemsListMobileState extends State<ItemsListMobile> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final itens = itemProvider.itens;

    return Scaffold(
      appBar: AppBar(title: const Text('Itens Cadastrados')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Buscar...', prefixIcon: Icon(Icons.search)),
              onChanged: (v) => setState(() => search = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, i) {
                final item = itens[i];
                if (!item.nome.toLowerCase().contains(search.toLowerCase())) return const SizedBox();

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.solicitante} • ${item.quantidade} un'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editItem(context, item)),
                        IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => _toggleStatus(context, item)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteItem(context, item.id)),
                        IconButton(icon: const Icon(Icons.qr_code, color: Colors.orange), onPressed: () => _showQRDialog(context, item)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleStatus(BuildContext context, Item item) async {
    final novoStatus = item.status == 'concluido' ? 'pendente' : 'concluido';
    await Provider.of<ItemProvider>(context, listen: false).atualizarStatus(item.id, novoStatus);
  }

  void _deleteItem(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Item'),
        content: const Text('Tem certeza?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Provider.of<ItemProvider>(context, listen: false).deletarItem(id);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item excluído')));
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editItem(BuildContext context, Item item) {
    // Mesmo diálogo simples do desktop
    final nomeCtrl = TextEditingController(text: item.nome);
    final qtdCtrl = TextEditingController(text: item.quantidade.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: qtdCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantidade')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final updated = Item(
                id: item.id,
                nome: nomeCtrl.text,
                categoria: item.categoria,
                quantidade: int.tryParse(qtdCtrl.text) ?? item.quantidade,
                dataLimite: item.dataLimite,
                solicitante: item.solicitante,
                observacao: item.observacao,
                status: item.status,
              );
              await Provider.of<ItemProvider>(context, listen: false).atualizarItem(updated);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item atualizado!')));
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showQRDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('QR Code - ${item.nome}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(15),
                child: QrImageView(data: item.id, size: 200),
              ),
              const SizedBox(height: 15),
              ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar')),
            ],
          ),
        ),
      ),
    );
  }
}