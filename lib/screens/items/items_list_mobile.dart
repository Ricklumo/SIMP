import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class ItemsListMobile extends StatefulWidget {
  const ItemsListMobile({super.key});

  @override
  State<ItemsListMobile> createState() => _ItemsListMobileState();
}

class _ItemsListMobileState extends State<ItemsListMobile> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final itens = provider.itens;

    return Scaffold(
      appBar: AppBar(title: const Text('Itens Cadastrados')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => search = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, i) {
                final item = itens[i];
                if (!item.nome.toLowerCase().contains(search.toLowerCase()))
                  return const SizedBox();

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      item.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item.solicitante} • ${item.quantidade} un',
                    ),
                    onTap: () =>
                        _showItemDetails(context, item), // ← linha clicável
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editItem(context, item),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          onPressed: () => _toggleStatus(context, item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteItem(context, item.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.qr_code, color: Colors.orange),
                          onPressed: () => _showQRDialog(context, item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solicitante: ${item.solicitante}'),
            const SizedBox(height: 8),
            Text(
              'Data Limite: ${item.dataLimite != null ? '${item.dataLimite!.day}/${item.dataLimite!.month}/${item.dataLimite!.year}' : 'Sem data'}',
            ),
            const SizedBox(height: 8),
            Text('Quantidade: ${item.quantidade}'),
            const SizedBox(height: 8),
            Text(
              'Observação: ${item.observacao.isEmpty ? 'Nenhuma' : item.observacao}',
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${item.status == 'concluido' ? 'Concluído' : 'Pendente'}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _toggleStatus(BuildContext context, Item item) async {
    final novoStatus = item.status == 'concluido' ? 'pendente' : 'concluido';
    await Provider.of<ItemProvider>(
      context,
      listen: false,
    ).atualizarStatus(item.id, novoStatus);
  }

  void _deleteItem(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Item'),
        content: const Text('Tem certeza?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Provider.of<ItemProvider>(
                context,
                listen: false,
              ).deletarItem(id);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Item excluído')));
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editItem(BuildContext context, Item item) {
    final nomeCtrl = TextEditingController(text: item.nome);
    final qtdCtrl = TextEditingController(text: item.quantidade.toString());
    final obsCtrl = TextEditingController(text: item.observacao);

    final provider = Provider.of<ItemProvider>(context, listen: false);
    User? selectedUser = provider.users.cast<User?>().firstWhere(
      (u) => u?.nome == item.solicitante,
      orElse: () => null,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: qtdCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
              ),

              DropdownButtonFormField<User>(
                value: selectedUser,
                hint: const Text('Selecione o Solicitante'),
                items: provider.users.map((user) {
                  return DropdownMenuItem<User>(
                    value: user,
                    child: Text('${user.nome} (${user.matricula})'),
                  );
                }).toList(),
                onChanged: (User? user) {
                  selectedUser = user;
                },
              ),

              TextField(
                controller: obsCtrl,
                decoration: const InputDecoration(labelText: 'Observação'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final updatedItem = Item(
                id: item.id,
                nome: nomeCtrl.text,
                categoria: item.categoria,
                quantidade: int.tryParse(qtdCtrl.text) ?? item.quantidade,
                dataLimite: item.dataLimite,
                solicitante: selectedUser?.nome ?? item.solicitante,
                observacao: obsCtrl.text,
                status: item.status,
              );
              await Provider.of<ItemProvider>(
                context,
                listen: false,
              ).atualizarItem(updatedItem);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Item atualizado!')));
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showQRDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QR Code - ${item.nome}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(15),
                child: QrImageView(data: item.id, size: 200),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Fechar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
