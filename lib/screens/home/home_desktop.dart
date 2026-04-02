import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/providers.dart';
import 'package:simp/widgets/sidebar.dart';
import '../dashboard/dashboard.dart';
import '../items/add_item.dart';
import '../items/items_list.dart';
import '../reports/reports.dart';
import '../users/add_user.dart'; // ← Import da tela de usuários

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  @override
  void initState() {
    super.initState();
    Provider.of<ItemProvider>(context, listen: false).carregarItens();
    Provider.of<ItemProvider>(context, listen: false).carregarUsers();
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);

    final List<Widget> pages = [
      const DashboardScreen(), // 0
      const AddItemScreen(), // 1
      ItemsListScreen(), // 2
      const AddUserScreen(), // 3 ← Usuários
      const ReportsScreen(), // 4 ← Relatórios
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
