import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'add_user.dart'; // para o botão de novo usuário

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Usuários / Instrutores')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddUserScreen()),
            ),
            child: const Icon(Icons.add),
          ),
          body: provider.users.isEmpty
              ? const Center(child: Text('Nenhum usuário cadastrado ainda'))
              : ListView.builder(
                  itemCount: provider.users.length,
                  itemBuilder: (context, index) {
                    final user = provider.users[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.nome),
                      subtitle: Text('Matrícula: ${user.matricula}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editUser(context, user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(context, user.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  void _editUser(BuildContext context, User user) {
    // Por enquanto só mostra um aviso (pode ser expandido depois)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Editar ${user.nome} - em breve')));
  }

  void _deleteUser(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Usuário'),
        content: const Text('Tem certeza que deseja excluir este usuário?'),
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
              ).deletarUser(id); // vamos criar este metodo no próximo passo
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Usuário excluído')));
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
