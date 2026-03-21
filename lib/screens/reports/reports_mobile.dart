import 'package:flutter/material.dart';
import 'package:simp/core/theme.dart';

class ReportsMobile extends StatefulWidget {
  const ReportsMobile({super.key});

  @override
  State<ReportsMobile> createState() => _ReportsMobileState();
}

class _ReportsMobileState extends State<ReportsMobile> {
  DateTime? dataInicio;
  DateTime? dataFim;

  final List<Map<String, dynamic>> movimentacoes = [
    {'item': 'Fios 2,5mm²', 'tipo': 'Saída', 'qtd': 15, 'data': DateTime(2026, 3, 19)},
    {'item': 'Disjuntor 10A', 'tipo': 'Entrada', 'qtd': 8, 'data': DateTime(2026, 3, 18)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: () async { /* date picker */ }, child: const Text('Data Inicial'))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: () async { /* date picker */ }, child: const Text('Data Final'))),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Resumo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(child: ListTile(title: const Text('Total Movimentações'), trailing: const Text('27'))),
            Card(child: ListTile(title: const Text('Itens Atrasados'), trailing: const Text('5', style: TextStyle(color: Colors.red)))),

            const SizedBox(height: 20),
            const Text('Histórico', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: movimentacoes.length,
                itemBuilder: (c, i) => ListTile(
                  title: Text('${movimentacoes[i]['item']} — ${movimentacoes[i]['tipo']}'),
                  subtitle: Text('${movimentacoes[i]['data'].day}/${movimentacoes[i]['data'].month}'),
                ),
              ),
            ),

            Row(
              children: [
                Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.picture_as_pdf), label: const Text('PDF'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => _export('PDF'))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.table_chart), label: const Text('Excel'), style: ElevatedButton.styleFrom(backgroundColor: SimpTheme.azul), onPressed: () => _export('Excel'))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _export(String tipo) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Relatório $tipo exportado!')));
  }
}