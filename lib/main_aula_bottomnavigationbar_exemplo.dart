import 'package:flutter/material.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override // <-- O único override do código!
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // O Builder garante o "contexto" correto para o alerta flutuar na tela
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('AlertDialog', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.purple,
          ),
          body: Center(
            // Um botão simples no centro da tela para disparar o alerta
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
              onPressed: () {
                // FOCO DA EXPLICAÇÃO: Função showDialog e o widget AlertDialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmação'),
                    content: const Text('Deseja excluir este produto do carrinho?'),
                    actions: [
                      // Botão 1: Apenas texto
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Fecha o alerta
                        child: const Text('Cancelar', style: TextStyle(color: Colors.purple)),
                      ),
                      // Botão 2: Destacado
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context), // Fecha o alerta
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                        child: const Text('Excluir'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Abrir Alerta'),
            ),
          ),
        ),
      ),
    );
  }
}