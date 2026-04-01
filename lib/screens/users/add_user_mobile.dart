import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simp/core/item_provider.dart';

class AddUserMobile extends StatefulWidget {
  const AddUserMobile({super.key});

  @override
  State<AddUserMobile> createState() => _AddUserMobileState();
}

class _AddUserMobileState extends State<AddUserMobile> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String matricula = '';
  String email = '';
  String telefone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome completo'),
                onChanged: (v) => nome = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Matrícula'),
                onChanged: (v) => matricula = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                onChanged: (v) => email = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Telefone'),
                onChanged: (v) => telefone = v,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
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
                      const SnackBar(content: Text('Usuário cadastrado!')),
                    );

                    setState(() {
                      nome = matricula = email = telefone = '';
                    });
                  }
                },
                child: const Text('Cadastrar Usuário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
