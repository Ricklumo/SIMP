import 'package:flutter/material.dart';
import 'package:simp/core/responsive.dart';
import 'package:simp/screens/items/add_item_desktop.dart';
import 'package:simp/screens/items/add_item_mobile.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context)) {
      return const AddItemDesktop();
    } else {
      return const AddItemMobile();
    }
  }
}