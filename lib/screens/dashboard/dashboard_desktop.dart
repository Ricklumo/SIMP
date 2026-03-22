import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class DashboardDesktop extends StatelessWidget {
  const DashboardDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final total = itemProvider.itens.length;
    final atrasados = itemProvider.itens.where((i) =>
    i.dataLimite != null && i.dataLimite!.isBefore(DateTime.now())).length;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📊 Dashboard', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 30),

            Row(
              children: [
                _buildCard('Total de Itens', total.toString(), Icons.inventory_2, SimpTheme.azul),
                const SizedBox(width: 20),
                _buildCard('Itens Atrasados', atrasados.toString(), Icons.warning, SimpTheme.vermelho),
                const SizedBox(width: 20),
                _buildCard('Pendentes', (total - atrasados).toString(), Icons.pending, SimpTheme.laranja),
              ],
            ),
            const SizedBox(height: 30),

            if (atrasados > 0)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '⚠️ $atrasados itens estão ATRASADOS!',
                    style: const TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}