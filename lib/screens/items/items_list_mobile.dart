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
                    trailing: IconButton(
                      icon: const Icon(Icons.qr_code, color: Colors.blue, size: 32),
                      onPressed: () => _showQRDialog(context, item),
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

  void _showQRDialog(BuildContext context, Item item) {
    print('🔄 Abrindo QR Code para: ${item.nome}');

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
                child: QrImageView(
                  data: item.id,
                  size: 200,
                  backgroundColor: Colors.white,
                  gapless: true,
                ),
              ),
              const SizedBox(height: 10),
              Text('ID: ${item.id}', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Fechar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}