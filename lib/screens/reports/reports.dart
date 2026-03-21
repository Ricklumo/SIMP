import 'package:flutter/material.dart';
import 'package:simp/core/responsive.dart';
import 'package:simp/screens/reports/reports_desktop.dart';
import 'package:simp/screens/reports/reports_mobile.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return isDesktop(context) ? const ReportsDesktop() : const ReportsMobile();
  }
}