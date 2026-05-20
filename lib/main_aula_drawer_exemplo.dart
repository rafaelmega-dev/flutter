import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override // <-- O único override do código!
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Componente: Drawer', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.purple,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: Text('Toque no ícone de menu (↖️) para abrir!')),
        
        // Estrutura do Drawer compactada
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.purple),
                child: Text('Minha Loja 🛒', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Início'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text('Produtos'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}