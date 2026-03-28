import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ← novo
import 'package:provider/provider.dart';
import 'package:simp/core/providers.dart';
import 'package:simp/core/theme.dart';

class SidebarMobile extends StatelessWidget {
  const SidebarMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SimpTheme.azul,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: [
          Center(
            child: Image.asset('assets/logo_simp_transparente.png', height: 90),
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.white24, thickness: 1),

          _buildItem(context, Icons.dashboard, 'Dashboard', 0),
          _buildItem(context, Icons.add_circle_outline, 'Novo Item', 1),
          _buildItem(context, Icons.inventory_2, 'Itens Cadastrados', 2),
          _buildItem(context, Icons.history, 'Relatórios', 3),
          _buildItem(context, Icons.logout, 'Sair', 4),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        if (index == 4) {
          _showSairDialog(context);
        } else {
          final nav = Provider.of<NavigationProvider>(context, listen: false);
          nav.changePage(index);
          Navigator.pop(context); // fecha o drawer
        }
      },
    );
  }

  void _showSairDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair do SIMP'),
        content: const Text('Deseja realmente sair do sistema?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              SystemNavigator.pop(); // fecha o app
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
