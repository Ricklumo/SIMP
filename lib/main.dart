import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/providers.dart';
import 'package:simp/core/theme.dart';
import 'package:simp/screens/home/home.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração da janela do Windows
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 700),           // Tamanho inicial
    minimumSize: Size(1000, 650),    // ← Tamanho MÍNIMO (não deixa ficar menor)
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Inicialização do SQLite para Windows
  databaseFactory = databaseFactoryFfi;

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
      title: 'SIMP – Sistema Inteligente de Materiais Pedagógicos',
      debugShowCheckedModeBanner: false,
      theme: SimpTheme.theme,
      home: const HomeScreen(),
    );
  }
}