import 'package:flutter/material.dart';
import 'package:simp/core/theme.dart';

class DashboardMobile extends StatelessWidget {
  const DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard', style: TextStyle(color: Colors.white),)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildCard('Itens Disponíveis', '248', Icons.inventory_2, SimpTheme.azul),
            const SizedBox(height: 12),
            _buildCard('Solicitações Pendentes', '12', Icons.pending, SimpTheme.laranja),
            const SizedBox(height: 12),
            _buildCard('Itens Atrasados', '5', Icons.warning, SimpTheme.vermelho),
            const SizedBox(height: 30),

            const Text('Top 5 Itens Mais Solicitados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const ListTile(leading: Icon(Icons.star), title: Text('Fios 2,5mm²'), trailing: Text('47')),
            const ListTile(leading: Icon(Icons.star), title: Text('Disjuntor 10A'), trailing: Text('32')),
            const ListTile(leading: Icon(Icons.star), title: Text('Lâmpada LED'), trailing: Text('28')),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        subtitle: Text(title),
      ),
    );
  }
}