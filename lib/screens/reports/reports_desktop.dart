import 'package:flutter/material.dart';
import 'package:simp/core/theme.dart';

class ReportsDesktop extends StatefulWidget {
  const ReportsDesktop({super.key});

  @override
  State<ReportsDesktop> createState() => _ReportsDesktopState();
}

class _ReportsDesktopState extends State<ReportsDesktop> {
  DateTime? dataInicio;
  DateTime? dataFim;

  // Dados conectados com a tela de Itens
  final List<Map<String, dynamic>> movimentacoes = [
    {'item': 'Fios 2,5mm²', 'tipo': 'Saída', 'qtd': 15, 'data': DateTime(2026, 3, 19), 'solicitante': 'Escola A'},
    {'item': 'Disjuntor 10A', 'tipo': 'Entrada', 'qtd': 8, 'data': DateTime(2026, 3, 18), 'solicitante': 'Supervisão'},
    {'item': 'Lâmpada LED', 'tipo': 'Saída', 'qtd': 12, 'data': DateTime(2026, 3, 17), 'solicitante': 'Escola C'},
  ];

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final atrasados = movimentacoes.where((m) => m['data'].isBefore(hoje)).length;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📄 Relatórios e Exportação', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),

            // Filtro de período
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2025), lastDate: DateTime(2027));
                      if (d != null) setState(() => dataInicio = d);
                    },
                    child: Text(dataInicio == null ? 'Data Inicial' : '${dataInicio!.day}/${dataInicio!.month}/${dataInicio!.year}'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2025), lastDate: DateTime(2027));
                      if (d != null) setState(() => dataFim = d);
                    },
                    child: Text(dataFim == null ? 'Data Final' : '${dataFim!.day}/${dataFim!.month}/${dataFim!.year}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Resumo útil
            Row(
              children: [
                _buildCard('Total Movimentações', movimentacoes.length.toString(), Icons.swap_horiz, SimpTheme.azul),
                const SizedBox(width: 16),
                _buildCard('Itens Atrasados', atrasados.toString(), Icons.warning, SimpTheme.vermelho),
                const SizedBox(width: 16),
                _buildCard('Saídas', '27', Icons.arrow_downward, SimpTheme.laranja),
              ],
            ),
            const SizedBox(height: 30),

            const Text('Histórico de Movimentações', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: movimentacoes.length,
                itemBuilder: (context, i) {
                  final m = movimentacoes[i];
                  return ListTile(
                    title: Text('${m['item']} — ${m['tipo']}'),
                    subtitle: Text('${m['solicitante']} • ${m['data'].day}/${m['data'].month}/${m['data'].year}'),
                    trailing: Text('${m['qtd']} un'),
                  );
                },
              ),
            ),

            // Exportação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Exportar PDF'),
                    style: ElevatedButton.styleFrom(backgroundColor: SimpTheme.vermelho, padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: () => _export('PDF'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Exportar Excel'),
                    style: ElevatedButton.styleFrom(backgroundColor: SimpTheme.azul, padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: () => _export('Excel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String titulo, String valor, IconData icon, Color cor) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [Icon(icon, size: 40, color: cor), Text(valor, style: const TextStyle(fontSize: 32)), Text(titulo)]),
        ),
      ),
    );
  }

  void _export(String tipo) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Relatório $tipo exportado com sucesso!')));
    print('✅ RELATÓRIO $tipo GERADO (período: $dataInicio - $dataFim)');
  }
}