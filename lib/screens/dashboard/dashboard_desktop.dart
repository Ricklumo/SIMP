import 'package:flutter/material.dart';
import 'package:simp/core/theme.dart';

class DashboardDesktop extends StatelessWidget {
  const DashboardDesktop({super.key});

  @override
  Widget build(BuildContext context) {
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
                _buildCard('Itens Disponíveis', '248', Icons.inventory_2, SimpTheme.azul),
                const SizedBox(width: 20),
                _buildCard('Solicitações Pendentes', '12', Icons.pending, SimpTheme.laranja),
                const SizedBox(width: 20),
                _buildCard('Itens Atrasados', '5', Icons.warning, SimpTheme.vermelho),
              ],
            ),
            const SizedBox(height: 30),

            const Text('Top 5 Itens Mais Solicitados', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.star), title: Text('Fios 2,5mm²'), trailing: Text('47 solicitações')),
                  ListTile(leading: Icon(Icons.star), title: Text('Disjuntor 10A'), trailing: Text('32 solicitações')),
                  ListTile(leading: Icon(Icons.star), title: Text('Lâmpada LED'), trailing: Text('28 solicitações')),
                ],
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