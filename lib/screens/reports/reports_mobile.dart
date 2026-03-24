import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class ReportsMobile extends StatelessWidget {
  const ReportsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final total = provider.itens.length;
    final atrasados = provider.itens
        .where(
          (i) => i.dataLimite != null && i.dataLimite!.isBefore(DateTime.now()),
        )
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildCard('Total', total.toString(), SimpTheme.azul),
                const SizedBox(width: 12),
                _buildCard(
                  'Atrasados',
                  atrasados.toString(),
                  SimpTheme.vermelho,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Histórico',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.itens.length,
                itemBuilder: (c, i) {
                  final item = provider.itens[i];
                  return ListTile(
                    title: Text(item.nome),
                    subtitle: Text(item.solicitante),
                    trailing:
                        item.dataLimite != null &&
                            item.dataLimite!.isBefore(DateTime.now())
                        ? const Icon(Icons.warning, color: Colors.red)
                        : const Icon(Icons.check_circle, color: Colors.green),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(value, style: const TextStyle(fontSize: 28)),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
