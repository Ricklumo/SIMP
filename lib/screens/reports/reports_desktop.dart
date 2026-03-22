import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class ReportsDesktop extends StatelessWidget {
  const ReportsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final total = itemProvider.itens.length;
    final atrasados = itemProvider.itens.where((i) => i.dataLimite != null && i.dataLimite!.isBefore(DateTime.now())).length;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📄 Relatórios', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 30),

            Row(
              children: [
                _buildCard('Total Movimentações', total.toString(), Icons.swap_horiz, SimpTheme.azul),
                const SizedBox(width: 16),
                _buildCard('Itens Atrasados', atrasados.toString(), Icons.warning, SimpTheme.vermelho),
              ],
            ),
            const SizedBox(height: 30),

            const Text('Histórico', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: itemProvider.itens.length,
                itemBuilder: (context, i) {
                  final item = itemProvider.itens[i];
                  return ListTile(
                    title: Text(item.nome),
                    subtitle: Text('${item.solicitante} • ${item.dataLimite != null ? item.dataLimite!.day.toString() : ''}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String titulo, String valor, IconData icon, Color cor) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [Icon(icon, size: 40, color: cor), Text(valor, style: const TextStyle(fontSize: 32)), Text(titulo)]),
        ),
      ),
    );
  }
}