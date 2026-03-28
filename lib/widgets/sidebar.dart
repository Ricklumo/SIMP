import 'package:flutter/material.dart';
import 'package:simp/core/theme.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: SimpTheme.azul,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Image.asset('assets/logo_simp_transparente.png', height: 150),
          const SizedBox(height: 40),
          _buildItem(Icons.dashboard, 'Dashboard', 0),
          _buildItem(Icons.add_circle, 'Novo Item', 1),
          _buildItem(Icons.inventory, 'Itens', 2),
          _buildItem(Icons.history, 'Relatórios', 3),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, int index) {
    final isSelected = index == selectedIndex;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
      ),
      selected: isSelected,
      onTap: () => onItemSelected(index),
    );
  }
}
