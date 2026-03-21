import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class ItemsListDesktop extends StatefulWidget {
  const ItemsListDesktop({super.key});

  @override
  State<ItemsListDesktop> createState() => _ItemsListDesktopState();
}

class _ItemsListDesktopState extends State<ItemsListDesktop> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final itens = itemProvider.itens;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Buscar item...', prefixIcon: Icon(Icons.search)),
              onChanged: (v) => setState(() => search = v),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Item')),
                    DataColumn(label: Text('Qtd')),
                    DataColumn(label: Text('Data Limite')),
                    DataColumn(label: Text('Solicitante')),
                    DataColumn(label: Text('QR Code')),
                  ],
                  rows: itens
                      .where((item) => item.nome.toLowerCase().contains(search.toLowerCase()))
                      .map((item) => DataRow(cells: [
                    DataCell(Text(item.nome)),
                    DataCell(Text(item.quantidade.toString())),
                    DataCell(Text(item.dataLimite != null
                        ? '${item.dataLimite!.day}/${item.dataLimite!.month}/${item.dataLimite!.year}'
                        : 'Sem data')),
                    DataCell(Text(item.solicitante)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.qr_code, color: Colors.blue, size: 32),
                        onPressed: () => _showQRDialog(context, item),
                      ),
                    ),
                  ]))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQRDialog(BuildContext context, Item item) {
    print('🔄 Abrindo QR Code para: ${item.nome}'); // para ver no console

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('QR Code - ${item.nome}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: QrImageView(
                  data: item.id,
                  size: 220,
                  backgroundColor: Colors.white,
                  gapless: true,
                ),
              ),
              const SizedBox(height: 10),
              Text('ID: ${item.id}', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 20),
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