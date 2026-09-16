import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MeuApp(),
    ));

// --- MODELO DA TAREFA ---
class Tarefa {
  String titulo;
  String horario;
  bool concluida;
  String dia;
  Color corLateral;
  String? caminhoImagem; // Guarda o caminho da foto no celular

  Tarefa({
    required this.titulo,
    required this.horario,
    this.concluida = false,
    this.dia = 'Hoje',
    this.corLateral = Colors.blue,
    this.caminhoImagem, // Opcional
  });
}

// --- TELAS SIMPLES DO DRAWER ---
class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: const Center(child: Text('Tela de Configurações bem simples!')),
    );
  }
}

class TelaAjuda extends StatelessWidget {
  const TelaAjuda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajuda')),
      body: const Center(child: Text('Tela de Ajuda bem simples!')),
    );
  }
}

// --- APP PRINCIPAL ---
class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  int _abaInferior = 0;
  final Color corPrincipal = const Color.fromARGB(255, 39, 126, 176);

  List<Tarefa> tarefas = [
    Tarefa(titulo: 'Estudar Flutter', horario: '10:00', dia: 'Hoje', corLateral: Colors.blue),
    Tarefa(titulo: 'Reunião com equipe', horario: '14:00', dia: 'Hoje', corLateral: Colors.red),
    Tarefa(titulo: 'Enviar relatório', horario: '16:30', dia: 'Hoje', corLateral: Colors.amber),
    Tarefa(titulo: 'Fazer compras', horario: '09:00', dia: 'Amanhã', corLateral: const Color(0xFF2C3E50)),
    Tarefa(titulo: 'Ler livro', horario: '20:00', dia: 'Amanhã', corLateral: const Color(0xFF2C3E50)),
    Tarefa(
      titulo: 'Pagar conta de luz',
      horario: 'Ontem',
      concluida: true,
      corLateral: Colors.green,
    ),
    Tarefa(
      titulo: 'Academia',
      horario: 'Ontem',
      concluida: true,
      corLateral: Colors.green,
    ),
  ];

  void adicionarTarefa() {
    final tituloController = TextEditingController();
    final horarioController = TextEditingController();
    String diaSelecionado = 'Hoje';
    
    String? caminhoFotoTemporaria;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nova tarefa'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tituloController,
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Nome da tarefa', prefixIcon: Icon(Icons.task)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: horarioController,
                      decoration: const InputDecoration(labelText: 'Horário', prefixIcon: Icon(Icons.access_time)),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: diaSelecionado,
                      items: const [
                        DropdownMenuItem<String>(value: 'Hoje', child: Text('Hoje')),
                        DropdownMenuItem<String>(value: 'Amanhã', child: Text('Amanhã')),
                      ],
                      onChanged: (String? valor) {
                        if (valor != null) {
                          setStateDialog(() {
                            diaSelecionado = valor;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Quando?', prefixIcon: Icon(Icons.calendar_month)),
                    ),
                    const SizedBox(height: 16),
                    
                    // Botão da Câmera
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final XFile? foto = await picker.pickImage(source: ImageSource.camera);
                          if (foto != null) {
                            setStateDialog(() {
                              caminhoFotoTemporaria = foto.path;
                            });
                          }
                        } catch (e) {
                          print("Erro ao abrir a câmera: $e");
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tirar Foto (Opcional)'),
                    ),
                    
                    // Exibição da miniatura no formulário (com tamanho fixo para não quebrar)
                    if (caminhoFotoTemporaria != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(caminhoFotoTemporaria!),
                          height: 120,
                          width: 250, // Largura fixa evita o erro de tela branca
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              const Text('Erro ao exibir a imagem.', style: TextStyle(color: Colors.red)),
                        ),
                      )
                    ]
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final titulo = tituloController.text.trim();
                    final horario = horarioController.text.trim();

                    if (titulo.isEmpty) return;

                    setState(() {
                      tarefas.add(Tarefa(
                        titulo: titulo,
                        horario: horario.isEmpty ? '--:--' : horario,
                        dia: diaSelecionado,
                        corLateral: diaSelecionado == 'Hoje' ? Colors.blue : const Color(0xFF2C3E50),
                        caminhoImagem: caminhoFotoTemporaria, 
                      ));
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void excluirTarefa(Tarefa tarefa) {
    setState(() {
      tarefas.remove(tarefa);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa excluída.')),
    );
  }

  // --- WIDGETS DE CONSTRUÇÃO DA LISTA ---
  Widget _construirCabecalhoSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: corPrincipal,
        ),
      ),
    );
  }

  Widget _construirCardTarefa(Tarefa tarefa) {
    final corDaBarra = tarefa.concluida ? Colors.green : tarefa.corLateral;

    return Dismissible(
      key: Key(tarefa.titulo + tarefa.horario + (tarefa.caminhoImagem ?? '')),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => excluirTarefa(tarefa),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: corDaBarra, width: 5)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              
              // Exibição da miniatura da foto na lista de tarefas
              leading: tarefa.caminhoImagem != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        File(tarefa.caminhoImagem!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      ),
                    )
                  : const Icon(Icons.task_alt, size: 40, color: Colors.grey),
                  
              title: Text(
                tarefa.titulo,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: tarefa.concluida ? Colors.grey : Colors.black87,
                  decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                tarefa.horario,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              trailing: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: tarefa.concluida,
                  activeColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  side: BorderSide(color: Colors.grey.shade400, width: 2),
                  onChanged: (valor) {
                    setState(() {
                      tarefa.concluida = valor ?? false;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirListaFiltrada(bool mostrarHoje, bool mostrarAmanha, bool mostrarConcluidas) {
    final tarefasHoje = tarefas.where((t) => !t.concluida && t.dia == 'Hoje').toList();
    final tarefasAmanha = tarefas.where((t) => !t.concluida && t.dia == 'Amanhã').toList();
    final tarefasConcluidas = tarefas.where((t) => t.concluida).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        if (mostrarHoje && tarefasHoje.isNotEmpty) ...[
          _construirCabecalhoSecao('Hoje'),
          ...tarefasHoje.map((t) => _construirCardTarefa(t)),
        ],
        if (mostrarAmanha && tarefasAmanha.isNotEmpty) ...[
          _construirCabecalhoSecao('Amanhã'),
          ...tarefasAmanha.map((t) => _construirCardTarefa(t)),
        ],
        if (mostrarConcluidas && tarefasConcluidas.isNotEmpty) ...[
          _construirCabecalhoSecao('Concluídas'),
          ...tarefasConcluidas.map((t) => _construirCardTarefa(t)),
        ],
        if (tarefasHoje.isEmpty && tarefasAmanha.isEmpty && tarefasConcluidas.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: Text('Nenhuma tarefa encontrada.', style: TextStyle(color: Colors.grey))),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Minhas Tarefas'),
          centerTitle: true,
          backgroundColor: corPrincipal,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, size: 28),
              onPressed: adicionarTarefa,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: corPrincipal),
                child: const Text('Tarefas 📝', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.task),
                title: const Text('Minhas Tarefas'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaConfiguracoes()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Ajuda'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaAjuda()));
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: corPrincipal,
                unselectedLabelColor: Colors.grey,
                indicatorColor: corPrincipal,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Todas'),
                  Tab(text: 'Pendentes'),
                  Tab(text: 'Concluídas'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _construirListaFiltrada(true, true, true), 
                  _construirListaFiltrada(true, true, false), 
                  _construirListaFiltrada(false, false, true), 
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _abaInferior,
          selectedItemColor: corPrincipal,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _abaInferior = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tarefas'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendário'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Prioridades'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}