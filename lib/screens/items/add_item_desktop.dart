import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class AddItemDesktop extends StatefulWidget {
  const AddItemDesktop({super.key});

  @override
  State<AddItemDesktop> createState() => _AddItemDesktopState();
}

class _AddItemDesktopState extends State<AddItemDesktop> {
  String nome = '';
  String categoria = 'Fios';
  int quantidade = 1;
  DateTime? dataLimite;
  String solicitante = '';
  String observacao = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '➕ Novo Item',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Nome do Item'),
              onChanged: (v) => nome = v,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: categoria,
              items: [
                'Fios',
                'Disjuntores',
                'Lâmpadas',
                'Tomadas',
                'Outros',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => categoria = v!),
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Quantidade'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => quantidade = int.tryParse(v) ?? 1,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final data = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (data != null) setState(() => dataLimite = data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SimpTheme.laranja,
                    ),
                    child: Text(
                      dataLimite == null
                          ? 'Selecionar Data Limite'
                          : 'Data Limite: ${dataLimite!.day}/${dataLimite!.month}/${dataLimite!.year}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Solicitante'),
              onChanged: (v) => solicitante = v,
            ),
            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Observação'),
              maxLines: 3,
              onChanged: (v) => observacao = v,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: SimpTheme.azul,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  // ← ASYNC AQUI
                  if (nome.trim().isEmpty) return;

                  final item = Item(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nome: nome,
                    categoria: categoria,
                    quantidade: quantidade,
                    dataLimite: dataLimite,
                    solicitante: solicitante,
                    observacao: observacao,
                  );

                  await Provider.of<ItemProvider>(
                    context,
                    listen: false,
                  ).adicionarItem(item); // ← await

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item cadastrado com sucesso! 🎉'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  setState(() {
                    nome = '';
                    categoria = 'Fios';
                    quantidade = 1;
                    dataLimite = null;
                    solicitante = '';
                    observacao = '';
                  });
                },
                child: const Text(
                  'Cadastrar Item',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
