import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/navigation_provider.dart';
import 'package:simp/core/theme.dart';
import 'package:simp/screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();   // ← importante

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: const SimpApp(),
    ),
  );
}

class SimpApp extends StatelessWidget {
  const SimpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMP',
      debugShowCheckedModeBanner: false,
      theme: SimpTheme.theme,
      home: const HomeScreen(),
    );
  }
}