import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/navigation_provider.dart';
import 'package:simp/core/theme.dart';
import 'package:simp/widgets/sidebar.dart';
import '../dashboard/dashboard.dart';
import '../items/add_item.dart';
import '../items/items_list.dart';
import '../reports/reports.dart';

class HomeDesktop extends StatelessWidget {
  const HomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);

    // Carrega itens do Firebase + verifica atrasos automaticamente
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    itemProvider.carregarItens();

    final List<Widget> pages = [
      const DashboardScreen(),
      const AddItemScreen(),
      const ItemsListScreen(),
      const ReportsScreen(),
    ];

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: nav.currentIndex,
            onItemSelected: (index) => nav.changePage(index),
          ),
          Expanded(child: pages[nav.currentIndex]),
        ],
      ),
    );
  }
}