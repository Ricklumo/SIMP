import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class ReportsMobile extends StatelessWidget {
  const ReportsMobile({super.key});

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
          appBar: AppBar(
            title: const Text(
              'Relatórios',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildCard('Total', total.toString(), SimpTheme.azul),
                    const SizedBox(width: 12),
                    _buildCard(
                      'Atrasados',
                      atrasados.toString(),
                      SimpTheme.vermelho,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
                  label: const Text(
                    'Exportar PDF',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SimpTheme.vermelho,
                  ),
                  onPressed: () => _gerarPDF(context, provider.itens),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Histórico',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.itens.length,
                    itemBuilder: (c, i) {
                      final item = provider.itens[i];
                      return ListTile(
                        title: Text(item.nome),
                        subtitle: Text(item.solicitante),
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

  Widget _buildCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(value, style: const TextStyle(fontSize: 28)),
              Text(title),
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
    ).showSnackBar(SnackBar(content: Text('✅ PDF salvo em Documentos')));
  }
}
