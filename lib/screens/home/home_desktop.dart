import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/providers.dart';
import 'package:simp/widgets/sidebar.dart';
import '../dashboard/dashboard.dart';
import '../items/add_item.dart';
import '../items/items_list.dart';
import '../reports/reports.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);

    final List<Widget> pages = [
      const DashboardScreen(),
      const AddItemScreen(),
      ItemsListScreen(),
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
