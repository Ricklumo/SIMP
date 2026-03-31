import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class ReportsDesktop extends StatelessWidget {
  const ReportsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemProvider>(
      builder: (context, provider, child) {
        final total = provider.itens.length;
        final atrasados = provider.itens
            .where(
              (i) =>
                  i.status != 'concluido' &&
                  i.dataLimite != null &&
                  i.dataLimite!.isBefore(DateTime.now()),
            )
            .length;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📄 Relatórios',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 30),

                Row(
                  children: [
                    _buildCard(
                      'Total de Itens',
                      total.toString(),
                      Icons.swap_horiz,
                      SimpTheme.azul,
                    ),
                    const SizedBox(width: 16),
                    _buildCard(
                      'Itens Atrasados',
                      atrasados.toString(),
                      Icons.warning,
                      SimpTheme.vermelho,
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Exportar Relatório em PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SimpTheme.vermelho,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () => _gerarPDF(context, provider.itens),
                ),
                const SizedBox(height: 30),

                const Text(
                  'Histórico de Itens',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.itens.length,
                    itemBuilder: (context, i) {
                      final item = provider.itens[i];
                      return ListTile(
                        title: Text(item.nome),
                        subtitle: Text(
                          '${item.solicitante} • ${item.quantidade} un',
                        ),
                        trailing: _buildStatusIcon(item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(String titulo, String valor, IconData icon, Color cor) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: cor),
              Text(valor, style: const TextStyle(fontSize: 32)),
              Text(titulo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(Item item) {
    if (item.status == 'concluido')
      return const Icon(Icons.check_circle, color: Colors.green);
    if (item.dataLimite != null && item.dataLimite!.isBefore(DateTime.now())) {
      return const Icon(Icons.warning, color: Colors.red);
    }
    return const Icon(Icons.access_time, color: Colors.grey);
  }

  Future<void> _gerarPDF(BuildContext context, List<Item> itens) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Relatório SIMP',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Gerado em: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Item', 'Qtd', 'Data Limite', 'Solicitante', 'Status'],
              data: itens
                  .map(
                    (item) => [
                      item.nome,
                      item.quantidade.toString(),
                      item.dataLimite != null
                          ? '${item.dataLimite!.day}/${item.dataLimite!.month}/${item.dataLimite!.year}'
                          : 'Sem data',
                      item.solicitante,
                      item.status == 'concluido' ? 'Concluído' : 'Pendente',
                    ],
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/relatorio_simp_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('✅ PDF salvo em: ${file.path}')));
  }
}
