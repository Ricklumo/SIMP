import 'package:flutter/material.dart';
import 'package:simp/core/responsive.dart';
import 'add_user_desktop.dart';
import 'add_user_mobile.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return isDesktop(context) ? const AddUserDesktop() : const AddUserMobile();
  }
}