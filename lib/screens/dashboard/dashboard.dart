import 'package:flutter/material.dart';
import 'package:simp/core/responsive.dart';
import 'package:simp/screens/dashboard/dashboard_desktop.dart';
import 'package:simp/screens/dashboard/dashboard_mobile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return isDesktop(
        context
    ) ? const DashboardDesktop() : const DashboardMobile();
  }
}
