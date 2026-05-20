import 'package:flutter/material.dart';

void main() {
   runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override // <-- O único override do código!
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Minha Loja', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.purple,
          actions: [
            // O componente PopupMenuButton direto na AppBar
            PopupMenuButton<String>(
              iconColor: Colors.white,
              onSelected: (opcao) => print('Clicou em: $opcao'),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'Editar', child: Text('Editar')),
                const PopupMenuItem(value: 'Excluir', child: Text('Excluir')),
                const PopupMenuItem(value: 'Compartilhar', child: Text('Compartilhar')),
              ],
            ),
          ],
        ),
        body: const Center(child: Text('Toque nos 3 pontinhos (⋮) no topo!')),
      ),
    );
  }
}