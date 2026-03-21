import 'package:flutter/material.dart';
import 'package:simp/core/responsive.dart';
import 'package:simp/screens/items/items_list_desktop.dart';
import 'package:simp/screens/items/items_list_mobile.dart';

class ItemsListScreen extends StatelessWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return isDesktop(context) ? const ItemsListDesktop() : const ItemsListMobile();
  }
}