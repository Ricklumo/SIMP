import 'package:flutter/material.dart';
import 'package:simp/core/responsive.dart';
import 'package:simp/screens/home/home_desktop.dart';
import 'package:simp/screens/home/home_mobile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context)) {
      return const HomeDesktop();
    } else {
      return const Scaffold(
        drawer: Drawer(child: Text('Menu Mobile')),
        body: HomeMobile(),
      );
    }
  }
}