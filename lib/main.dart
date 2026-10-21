import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// =====================================================
// APLICATIVO
// =====================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const TarefasScreen(),
    );
  }
}

// =====================================================
// MODELO DA TAREFA
// =====================================================

class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final String? prioridade;
  final String? status;

  const Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    this.prioridade,
    this.status,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: int.tryParse('${json['id'] ?? ''}'),
      titulo: '${json['titulo'] ?? ''}',
      descricao: '${json['descricao'] ?? ''}',
      prioridade: json['prioridade']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'descricao': descricao,
      if (prioridade != null) 'prioridade': prioridade,
      if (status != null) 'status': status,
    };
  }
}

// =====================================================
// SERVIÇO DA API
// =====================================================

class TarefaService {
  // IP E ENDPOINT DO PROFESSOR: MANTIDOS.
  static const String baseUrl = 'http://10.140.170.19/pdm_api/tarefas.php';

  static const Duration timeout = Duration(seconds: 15);

  Uri get url => Uri.parse(baseUrl);

  // Converte a resposta HTTP em JSON.
  dynamic decodificarResposta(http.Response response) {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw Exception(
        'A API não retornou um JSON válido. '
        'Verifique a resposta do servidor PHP.',
      );
    }
  }

  // Mostra os erros retornados pelo servidor, quando disponíveis.
  String mensagemErro(http.Response response) {
    try {
      final dados = decodificarResposta(response);

      if (dados is Map) {
        final mensagem = dados['erro'] ?? dados['mensagem'] ?? dados['message'];

        if (mensagem != null) {
          return mensagem.toString();
        }
      }
    } catch (_) {
      // A resposta pode não estar em formato JSON.
    }

    return 'Erro HTTP ${response.statusCode}: '
        '${response.body.isEmpty ? "Sem detalhes do servidor." : response.body}';
  }

  void verificarResposta(
    http.Response response, {
    required List<int> statusAceitos,
  }) {
    if (!statusAceitos.contains(response.statusCode)) {
      throw Exception(mensagemErro(response));
    }
  }

  // GET: CONSULTAR TAREFAS
  Future<List<Tarefa>> listar() async {
    try {
      final response = await http.get(url).timeout(timeout);

      debugPrint('GET STATUS: ${response.statusCode}');
      debugPrint('GET RESPOSTA: ${response.body}');

      verificarResposta(response, statusAceitos: [200]);

      final resultado = decodificarResposta(response);

      dynamic dados;

      // Formato 1: a API retorna uma lista diretamente.
      if (resultado is List) {
        dados = resultado;
      }
      // Formato 2: a API retorna {"dados": [...]}.
      else if (resultado is Map && resultado['dados'] is List) {
        dados = resultado['dados'];
      }
      // Formato 3: algumas APIs utilizam {"tarefas": [...]}.
      else if (resultado is Map && resultado['tarefas'] is List) {
        dados = resultado['tarefas'];
      }
      // Formato 4: algumas APIs utilizam {"data": [...]}.
      else if (resultado is Map && resultado['data'] is List) {
        dados = resultado['data'];
      } else if (resultado is Map &&
          (resultado['erro'] != null || resultado['message'] != null)) {
        throw Exception('${resultado['erro'] ?? resultado['message']}');
      } else {
        throw Exception(
          'Formato de resposta inesperado. '
          'Confira o JSON retornado pela API.',
        );
      }

      return (dados as List).map<Tarefa>((item) {
        if (item is! Map) {
          throw Exception('Uma tarefa retornada está inválida.');
        }

        return Tarefa.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } on TimeoutException {
      throw Exception('Tempo limite excedido ao consultar a API.');
    } on http.ClientException catch (e) {
      throw Exception('Falha na conexão com a API: $e');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erro ao consultar tarefas: $e');
    }
  }

  // POST: CADASTRAR TAREFA
  Future<void> criar(Tarefa tarefa) async {
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(tarefa.toJson()),
          )
          .timeout(timeout);

      debugPrint('POST STATUS: ${response.statusCode}');
      debugPrint('POST RESPOSTA: ${response.body}');

      verificarResposta(response, statusAceitos: [200, 201, 204]);
    } on TimeoutException {
      throw Exception('Tempo limite ao cadastrar a tarefa.');
    } on http.ClientException catch (e) {
      throw Exception('Falha de conexão ao cadastrar: $e');
    }
  }

  // PUT: ATUALIZAR TAREFA
  Future<void> atualizar(Tarefa tarefa) async {
    if (tarefa.id == null) {
      throw Exception('Não é possível atualizar sem um ID.');
    }

    try {
      // Mantém o ID na URL, como no código original.
      final endereco = Uri.parse('$baseUrl?id=${tarefa.id}');

      final response = await http
          .put(
            endereco,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(tarefa.toJson()),
          )
          .timeout(timeout);

      debugPrint('PUT STATUS: ${response.statusCode}');
      debugPrint('PUT RESPOSTA: ${response.body}');

      verificarResposta(response, statusAceitos: [200, 204]);
    } on TimeoutException {
      throw Exception('Tempo limite ao atualizar a tarefa.');
    } on http.ClientException catch (e) {
      throw Exception('Falha de conexão ao atualizar: $e');
    }
  }

  // DELETE: EXCLUIR TAREFA
  Future<void> deletar(int id) async {
    try {
      // Mantém o ID na URL, como no código original.
      final endereco = Uri.parse('$baseUrl?id=$id');

      final response = await http
          .delete(endereco, headers: {'Accept': 'application/json'})
          .timeout(timeout);

      debugPrint('DELETE STATUS: ${response.statusCode}');
      debugPrint('DELETE RESPOSTA: ${response.body}');

      verificarResposta(response, statusAceitos: [200, 204]);
    } on TimeoutException {
      throw Exception('Tempo limite ao excluir a tarefa.');
    } on http.ClientException catch (e) {
      throw Exception('Falha de conexão ao excluir: $e');
    }
  }
}

// =====================================================
// TELA PRINCIPAL
// =====================================================

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final TarefaService _service = TarefaService();

  List<Tarefa> _tarefas = [];

  bool _isLoading = true;
  bool _operando = false;
  String? _erro;

  int get _concluidas =>
      _tarefas.where((t) => t.status?.toLowerCase() == 'concluida').length;

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  // GET: carrega os dados da API.
  Future<void> _carregarTarefas() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      final resultado = await _service.listar();

      if (!mounted) return;

      setState(() {
        _tarefas = resultado;
      });
    } catch (e) {
      debugPrint('ERRO AO CARREGAR: $e');

      if (!mounted) return;

      setState(() {
        _erro = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarMensagem(String mensagem, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: isError
              ? Colors.red.shade700
              : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // POST: cria uma tarefa.
  // PUT: atualiza uma tarefa.
  Future<void> _salvarTarefa({
    Tarefa? original,
    required String titulo,
    required String descricao,
    required String prioridade,
    required String status,
  }) async {
    if (_operando) return;

    setState(() => _operando = true);

    try {
      if (original == null) {
        await _service.criar(
          Tarefa(
            titulo: titulo,
            descricao: descricao,
            prioridade: prioridade,
            status: status,
          ),
        );

        if (!mounted) return;

        _mostrarMensagem('Tarefa cadastrada com sucesso!');
      } else {
        await _service.atualizar(
          Tarefa(
            id: original.id,
            titulo: titulo,
            descricao: descricao,
            prioridade: prioridade,
            status: status,
          ),
        );

        if (!mounted) return;

        _mostrarMensagem('Tarefa atualizada com sucesso!');
      }

      await _carregarTarefas();
    } catch (e) {
      if (!mounted) return;

      _mostrarMensagem(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _operando = false);
      }
    }
  }

  // DELETE: exclui uma tarefa.
  Future<void> _deletarTarefa(Tarefa tarefa) async {
    if (tarefa.id == null || _operando) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir tarefa?'),
        content: Text('Deseja excluir "${tarefa.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _operando = true);

    try {
      await _service.deletar(tarefa.id!);

      if (!mounted) return;

      _mostrarMensagem('Tarefa excluída com sucesso!');

      await _carregarTarefas();
    } catch (e) {
      if (!mounted) return;

      _mostrarMensagem(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _operando = false);
      }
    }
  }

  // Formulário usado para cadastro e edição.
  Future<void> _abrirFormulario({Tarefa? tarefa}) async {
    if (_operando) return;

    final tituloController = TextEditingController(text: tarefa?.titulo ?? '');

    final descricaoController = TextEditingController(
      text: tarefa?.descricao ?? '',
    );

    String prioridade = tarefa?.prioridade ?? 'media';
    String status = tarefa?.status ?? 'pendente';

    final resultado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, atualizarFormulario) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      tarefa == null ? 'Nova tarefa' : 'Editar tarefa',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: tituloController,
                      maxLength: 150,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: ['baixa', 'media', 'alta'].contains(prioridade)
                          ? prioridade
                          : 'media',
                      decoration: const InputDecoration(
                        labelText: 'Prioridade',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'baixa', child: Text('Baixa')),
                        DropdownMenuItem(value: 'media', child: Text('Média')),
                        DropdownMenuItem(value: 'alta', child: Text('Alta')),
                      ],
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarFormulario(() {
                            prioridade = valor;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value:
                          [
                            'pendente',
                            'em andamento',
                            'concluida',
                          ].contains(status)
                          ? status
                          : 'pendente',
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'pendente',
                          child: Text('Pendente'),
                        ),
                        DropdownMenuItem(
                          value: 'em andamento',
                          child: Text('Em andamento'),
                        ),
                        DropdownMenuItem(
                          value: 'concluida',
                          child: Text('Concluída'),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarFormulario(() {
                            status = valor;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: Text(
                          tarefa == null ? 'Cadastrar' : 'Salvar alterações',
                        ),
                        onPressed: () {
                          if (tituloController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Informe o título da tarefa.'),
                              ),
                            );
                            return;
                          }

                          Navigator.pop(sheetContext, true);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    final titulo = tituloController.text.trim();
    final descricao = descricaoController.text.trim();

    tituloController.dispose();
    descricaoController.dispose();

    if (resultado != true || !mounted) return;

    await _salvarTarefa(
      original: tarefa,
      titulo: titulo,
      descricao: descricao,
      prioridade: prioridade,
      status: status,
    );
  }

  // =====================================================
  // INTERFACE
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final progresso = _tarefas.isEmpty ? 0.0 : _concluidas / _tarefas.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Tarefas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _isLoading || _operando ? null : _carregarTarefas,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _operando ? null : () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.task_alt, color: Colors.white, size: 38),
                const SizedBox(height: 12),
                const Text(
                  'Organize suas tarefas!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_concluidas de ${_tarefas.length} concluídas',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progresso,
                    minHeight: 8,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lista de tarefas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _construirConteudo()),
        ],
      ),
    );
  }

  Widget _construirConteudo() {
    if (_isLoading && _tarefas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null && _tarefas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 55, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'Não foi possível carregar as tarefas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _carregarTarefas,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_tarefas.isEmpty) {
      return RefreshIndicator(
        onRefresh: _carregarTarefas,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 80),
            Icon(Icons.inbox_outlined, size: 65, color: Colors.grey),
            SizedBox(height: 12),
            Center(child: Text('Nenhuma tarefa encontrada.')),
          ],
        ),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _carregarTarefas,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
            itemCount: _tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = _tarefas[index];

              final concluida = tarefa.status?.toLowerCase() == 'concluida';

              return Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: concluida
                        ? Colors.green.shade100
                        : Colors.blue.shade100,
                    child: Icon(
                      concluida
                          ? Icons.check_circle
                          : Icons.assignment_outlined,
                      color: concluida ? Colors.green : Colors.blue,
                    ),
                  ),
                  title: Text(
                    tarefa.titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: concluida
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tarefa.descricao.isEmpty
                              ? 'Sem descrição'
                              : tarefa.descricao,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _etiqueta(
                              tarefa.status ?? 'Sem status',
                              concluida ? Colors.green : Colors.orange,
                            ),
                            if (tarefa.prioridade != null)
                              _etiqueta(
                                'Prioridade: ${tarefa.prioridade}',
                                Colors.blue,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    enabled: !_operando,
                    onSelected: (opcao) {
                      if (opcao == 'editar') {
                        _abrirFormulario(tarefa: tarefa);
                      } else if (opcao == 'excluir') {
                        _deletarTarefa(tarefa);
                      } else if (opcao == 'concluir') {
                        _salvarTarefa(
                          original: tarefa,
                          titulo: tarefa.titulo,
                          descricao: tarefa.descricao,
                          prioridade: tarefa.prioridade ?? 'media',
                          status: concluida ? 'pendente' : 'concluida',
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'concluir',
                        child: Text(
                          concluida ? 'Reabrir tarefa' : 'Concluir tarefa',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'editar',
                        child: Text('Editar'),
                      ),
                      const PopupMenuItem(
                        value: 'excluir',
                        child: Text('Excluir'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading && _tarefas.isNotEmpty)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          ),
        if (_operando)
          Positioned.fill(
            child: Container(
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _etiqueta(String texto, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
