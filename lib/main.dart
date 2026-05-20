import 'package:flutter/material.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override // <-- Único override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('SnackBar'), titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, backgroundColor: Colors.purple)),
          body: Center(
            child: ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produto salvo com sucesso!')),
              ),
            ),
          ),
        ),
      ),
    );
  }
}