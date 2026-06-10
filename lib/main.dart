import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: AtividadeSenai(),
    debugShowCheckedModeBanner: false,
  ));
}

class AtividadeSenai extends StatefulWidget {
  const AtividadeSenai({super.key});

  @override
  State<AtividadeSenai> createState() => _AtividadeSenaiState();
}

class _AtividadeSenaiState extends State<AtividadeSenai> {
  bool _isLoading = false;

  // Função para simular a ação principal (Carregamento -> Sucesso)
  void _executarAcaoPrincipal() async {
    setState(() => _isLoading = true);

    // 1. Exibe indicador de carregamento por alguns segundos
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() => _isLoading = false);
      
      // 2. Mostra SnackBar informando sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ação realizada com sucesso!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // 3. Função para exibir AlertDialog ao tentar sair
  Future<bool> _confirmarSaida() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sair do Aplicativo?'),
            content: const Text('Deseja realmente interromper a navegação e continuar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('CANCELAR'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('SAIR'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // PopScope captura a tentativa de voltar/sair da tela
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final deveSair = await _confirmarSaida();
        if (deveSair && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Atividade SENAI'),
          backgroundColor: const Color(0xFF2E1A47), // Cor baseada no slide
          foregroundColor: Colors.white,
          actions: [
            // REQUISITO: PopupMenuButton com pelo menos 3 opções
            PopupMenuButton<String>(
              onSelected: (value) => print('Selecionou: $value'),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'perfil', child: Text('Meu Perfil')),
                const PopupMenuItem(value: 'config', child: Text('Configurações')),
                const PopupMenuItem(value: 'ajuda', child: Text('Ajuda e Suporte')),
              ],
            ),
          ],
        ),

        // REQUISITO: Menu lateral (Drawer)
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF2E1A47)),
                child: Text('Menu de Opções', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Sair'),
                onTap: () async {
                  if (await _confirmarSaida()) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        // REQUISITO: Corpo da tela com Cards e Botão Principal
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                // REQUISITO: CircularProgressIndicator durante a ação
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Processando dados...'),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      const Card(
                        child: ListTile(
                          leading: Icon(Icons.info),
                          title: Text('Informação do Sistema'),
                          subtitle: Text('Status: Operacional'),
                        ),
                      ),
                      const Card(
                        child: ListTile(
                          leading: Icon(Icons.storage),
                          title: Text('Dados Sincronizados'),
                          subtitle: Text('Última atualização: Hoje'),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // REQUISITO: Botão principal para realizar uma ação
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E1A47),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: _executarAcaoPrincipal,
                        child: const Text('REALIZAR AÇÃO PRINCIPAL'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}