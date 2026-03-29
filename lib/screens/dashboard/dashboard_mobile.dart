import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemProvider>(
      builder: (context, provider, child) {
        final total = provider.itens.length;
        final atrasados = provider.itens
            .where(
              (i) =>
                  i.dataLimite != null &&
                  i.dataLimite!.isBefore(DateTime.now()),
            )
            .length;

        return Scaffold(
          appBar: AppBar(title: const Text('Dashboard')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _buildCard(
                  'Total de Itens',
                  total.toString(),
                  Icons.inventory_2,
                  SimpTheme.azul,
                ),
                const SizedBox(height: 12),
                _buildCard(
                  'Itens Atrasados',
                  atrasados.toString(),
                  Icons.warning,
                  SimpTheme.vermelho,
                ),
                const SizedBox(height: 12),
                _buildCard(
                  'Pendentes',
                  (total - atrasados).toString(),
                  Icons.pending,
                  SimpTheme.laranja,
                ),

                if (atrasados > 0)
                  Card(
                    color: Colors.red.shade50,
                    margin: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      leading: const Icon(
                        Icons.warning,
                        color: Colors.red,
                        size: 32,
                      ),
                      title: Text(
                        '$atrasados itens atrasados!',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(title),
      ),
    );
  }
}
