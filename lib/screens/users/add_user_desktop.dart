import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';
import 'package:simp/core/theme.dart';

class AddUserDesktop extends StatefulWidget {
  const AddUserDesktop({super.key});

  @override
  State<AddUserDesktop> createState() => _AddUserDesktopState();
}

class _AddUserDesktopState extends State<AddUserDesktop> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String matricula = '';
  String email = '';
  String telefone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Usuário / Instrutor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome completo'),
                onChanged: (v) => nome = v,
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Matrícula'),
                onChanged: (v) => matricula = v,
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                onChanged: (v) => email = v,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Telefone'),
                onChanged: (v) => telefone = v,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final user = User(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        nome: nome,
                        matricula: matricula,
                        email: email.isEmpty ? null : email,
                        telefone: telefone.isEmpty ? null : telefone,
                      );

                      await Provider.of<ItemProvider>(
                        context,
                        listen: false,
                      ).adicionarUser(user);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuário cadastrado com sucesso!'),
                        ),
                      );

                      Navigator.pop(context); // ← Volta automaticamente
                    }
                  },
                  child: const Text(
                    'Cadastrar Usuário',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
