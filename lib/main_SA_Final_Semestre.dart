import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ============================================================================
// APLICATIVO DE FINANÇAS PESSOAIS
// Todo o código está contido neste único arquivo.
// ============================================================================

void main() {
  runApp(const FinancasApp());
}

// ----------------------------------------------------------------------------
// CONSTANTES DE COR
// ----------------------------------------------------------------------------
const Color laranja = Color(0xFFFF7A00);
const Color verde = Color(0xFF2E9E4F);
const Color vermelho = Color(0xFFE03548);
const Color fundoCinza = Color(0xFFF5F6F8);
const Color textoPreto = Color(0xFF1A1A1A);
const Color textoCinza = Color(0xFF8A8A8E);

// ----------------------------------------------------------------------------
// MODELO DE TRANSAÇÃO
// ----------------------------------------------------------------------------
enum TipoTransacao { receita, despesa }

class Transaction {
  final String id;
  String descricao;
  double valor;
  TipoTransacao tipo;
  String categoria;
  DateTime data;
  String observacao;

  Transaction({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.categoria,
    required this.data,
    this.observacao = '',
  });

  Transaction copiar() => Transaction(
        id: id,
        descricao: descricao,
        valor: valor,
        tipo: tipo,
        categoria: categoria,
        data: data,
        observacao: observacao,
      );
}

// ----------------------------------------------------------------------------
// CATEGORIA (nome + ícone + cor)
// ----------------------------------------------------------------------------
class CategoriaInfo {
  final String nome;
  final IconData icone;
  final Color cor;

  const CategoriaInfo(this.nome, this.icone, this.cor);
}

const List<CategoriaInfo> categorias = [
  CategoriaInfo('Salário', Icons.payments, Color(0xFF2E9E4F)),
  CategoriaInfo('Alimentação', Icons.restaurant_menu, Color(0xFFFF7A00)),
  CategoriaInfo('Supermercado', Icons.shopping_cart, Color(0xFF7E57C2)),
  CategoriaInfo('Transporte', Icons.directions_bus, Color(0xFF29B6F6)),
  CategoriaInfo('Combustível', Icons.local_gas_station, Color(0xFFEF6C00)),
  CategoriaInfo('Moradia', Icons.home_work, Color(0xFF8D6E63)),
  CategoriaInfo('Aluguel', Icons.villa, Color(0xFF5C6BC0)),
  CategoriaInfo('Internet', Icons.wifi, Color(0xFF26A69A)),
  CategoriaInfo('Educação', Icons.school, Color(0xFF42A5F5)),
  CategoriaInfo('Saúde', Icons.favorite, Color(0xFFEC407A)),
  CategoriaInfo('Lazer', Icons.sports_esports, Color(0xFFAB47BC)),
  CategoriaInfo('Restaurantes', Icons.dinner_dining, Color(0xFFFF7043)),
  CategoriaInfo('Compras', Icons.shopping_bag, Color(0xFF66BB6A)),
  CategoriaInfo('Investimentos', Icons.trending_up, Color(0xFF1E88E5)),
  CategoriaInfo('Outros', Icons.category, Color(0xFF78909C)),
];

CategoriaInfo categoriaPorNome(String nome) {
  for (final c in categorias) {
    if (c.nome == nome) return c;
  }
  return categorias.last;
}

// ----------------------------------------------------------------------------
// UTILITÁRIOS DE FORMATAÇÃO
// ----------------------------------------------------------------------------
String formatarMoeda(double valor) {
  final negativo = valor < 0;
  final abs = valor.abs();
  final texto = abs.toStringAsFixed(2).replaceAll('.', ',');
  final partes = texto.split(',');
  final inteiro = partes[0];
  final decimal = partes[1];
  final buffer = StringBuffer();
  for (int i = 0; i < inteiro.length; i++) {
    if (i > 0 && (inteiro.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(inteiro[i]);
  }
  final resultado = 'R\$ $buffer,$decimal';
  return negativo ? '-$resultado' : resultado;
}

String formatarData(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yyyy = d.year.toString();
  return '$dd/$mm/$yyyy';
}

String nomeMes(int mes) {
  const meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];
  return meses[mes - 1];
}

// ----------------------------------------------------------------------------
// APP RAIZ COM ESTADO GLOBAL
// ----------------------------------------------------------------------------
class FinancasApp extends StatefulWidget {
  const FinancasApp({super.key});

  @override
  State<FinancasApp> createState() => _FinancasAppState();
}

class _FinancasAppState extends State<FinancasApp> {
  final List<Transaction> _transacoes = [];
  DateTime _mesSelecionado = DateTime.now();
  int _abaAtiva = 0;
String _filtroTipo = 'Todas';
  String? _filtroCategoria;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _carregarDadosExemplo();
  }

  // Dados iniciais para demonstrar o app funcionando.
  void _carregarDadosExemplo() {
    final agora = DateTime.now();
    _transacoes.addAll([
      Transaction(
        id: '1',
        descricao: 'Salário',
        valor: 5200.00,
        tipo: TipoTransacao.receita,
        categoria: 'Salário',
        data: DateTime(agora.year, agora.month, 1),
        observacao: 'Salário mensal',
      ),
      Transaction(
        id: '2',
        descricao: 'Aluguel',
        valor: 1500.00,
        tipo: TipoTransacao.despesa,
        categoria: 'Aluguel',
        data: DateTime(agora.year, agora.month, 5),
      ),
      Transaction(
        id: '3',
        descricao: 'Supermercado',
        valor: 320.50,
        tipo: TipoTransacao.despesa,
        categoria: 'Supermercado',
        data: DateTime(agora.year, agora.month, 7),
      ),
      Transaction(
        id: '4',
        descricao: 'Internet',
        valor: 99.90,
        tipo: TipoTransacao.despesa,
        categoria: 'Internet',
        data: DateTime(agora.year, agora.month, 10),
      ),
      Transaction(
        id: '5',
        descricao: 'Combustível',
        valor: 200.00,
        tipo: TipoTransacao.despesa,
        categoria: 'Combustível',
        data: DateTime(agora.year, agora.month, 12),
      ),
      Transaction(
        id: '6',
        descricao: 'Restaurante',
        valor: 150.00,
        tipo: TipoTransacao.despesa,
        categoria: 'Restaurantes',
        data: DateTime(agora.year, agora.month, 15),
        observacao: 'Jantar com amigos',
      ),
    ]);
  }

  // ---------------- CÁLCULOS ----------------
  List<Transaction> get _transacoesDoMes {
    return _transacoes
        .where((t) =>
            t.data.month == _mesSelecionado.month &&
            t.data.year == _mesSelecionado.year)
        .toList();
  }

  double get _totalReceitas {
    double total = 0;
    for (final t in _transacoesDoMes) {
      if (t.tipo == TipoTransacao.receita) total += t.valor;
    }
    return total;
  }

  double get _totalDespesas {
    double total = 0;
    for (final t in _transacoesDoMes) {
      if (t.tipo == TipoTransacao.despesa) total += t.valor;
    }
    return total;
  }

  double get _saldo => _totalReceitas - _totalDespesas;

  List<Transaction> get _transacoesFiltradas {
    var lista = _transacoesDoMes;
    if (_filtroTipo == 'Receitas') {
      lista = lista.where((t) => t.tipo == TipoTransacao.receita).toList();
    } else if (_filtroTipo == 'Despesas') {
      lista = lista.where((t) => t.tipo == TipoTransacao.despesa).toList();
    }
    if (_filtroCategoria != null) {
      lista = lista.where((t) => t.categoria == _filtroCategoria).toList();
    }
    lista.sort((a, b) => b.data.compareTo(a.data));
    return lista;
  }

  // ---------------- OPERAÇÕES ----------------
  void _adicionar(Transaction t) {
    setState(() => _transacoes.add(t));
  }

  void _atualizar(String id, Transaction nova) {
    setState(() {
      final idx = _transacoes.indexWhere((t) => t.id == id);
      if (idx != -1) _transacoes[idx] = nova;
    });
  }

  void _excluir(String id) {
    setState(() {
      _transacoes.removeWhere((t) => t.id == id);
    });
  }

  void _mudarMes(int delta) {
    setState(() {
      _mesSelecionado =
          DateTime(_mesSelecionado.year, _mesSelecionado.month + delta, 1);
    });
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: laranja,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ---------------- CAMBIO DE ABA ----------------
  void _irParaAba(int idx) {
    setState(() => _abaAtiva = idx);
    _scaffoldKey.currentState?.closeDrawer();
  }

// ---------------- FORMULÁRIO ADD/EDIT ----------------
  Future<void> _abrirFormulario({Transaction? existente}) async {
    final resultado = await showModalBottomSheet<Transaction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FormularioTransacao(
        transacaoExistente: existente,
        categorias: categorias,
      ),
    );
    if (resultado != null) {
      if (existente == null) {
        _adicionar(resultado);
        _mostrarSnack('Movimentação adicionada com sucesso!');
      } else {
        _atualizar(existente.id, resultado);
        _mostrarSnack('Movimentação atualizada com sucesso!');
      }
    }
  }

  // ---------------- CONFIRMAÇÃO DE EXCLUSÃO ----------------
  Future<void> _confirmarExclusao(Transaction t) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Excluir movimentação?'),
        content: const Text(
          'Tem certeza de que deseja excluir esta movimentação?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: textoCinza)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: vermelho, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    if (confirmou == true) {
      _excluir(t.id);
      _mostrarSnack('Movimentação excluída com sucesso!');
    }
  }

  // ---------------- FILTRO ----------------
  Future<void> _abrirFiltros() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _PainelFiltros(
        tipo: _filtroTipo,
        categoria: _filtroCategoria,
        aoAplicar: (tipo, categoria) {
          setState(() {
            _filtroTipo = tipo;
            _filtroCategoria = categoria;
          });
        },
      ),
    );
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
final telas = [
      _ResumoScreen(
        mes: _mesSelecionado,
        totalReceitas: _totalReceitas,
        totalDespesas: _totalDespesas,
        saldo: _saldo,
        transacoes: _transacoesFiltradas,
        onMudarMes: _mudarMes,
        onAdicionar: () => _abrirFormulario(),
        onEditar: (t) => _abrirFormulario(existente: t),
        onExcluir: _confirmarExclusao,
        onFiltrar: _abrirFiltros,
        onVerTodas: () => _irParaAba(1),
      ),
      _TransacoesScreen(
        transacoes: _transacoesFiltradas,
        filtroTipo: _filtroTipo,
        onAdicionar: () => _abrirFormulario(),
        onEditar: (t) => _abrirFormulario(existente: t),
        onExcluir: _confirmarExclusao,
        onFiltrar: _abrirFiltros,
      ),
      const _CategoriasScreen(),
      _RelatoriosScreen(
        transacoesDoMes: _transacoesDoMes,
        mes: _mesSelecionado,
        totalReceitas: _totalReceitas,
        totalDespesas: _totalDespesas,
        saldo: _saldo,
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanças',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: fundoCinza,
        colorScheme: ColorScheme.fromSeed(
          seedColor: laranja,
          primary: laranja,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: laranja,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: laranja,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: laranja,
          unselectedItemColor: textoCinza,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        drawer: _DrawerMenu(
          abaAtiva: _abaAtiva,
          onSelecionar: _irParaAba,
        ),
        body: IndexedStack(index: _abaAtiva, children: telas),
        floatingActionButton: _abaAtiva <= 1
            ? FloatingActionButton(
                onPressed: _abrirFormulario,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 32),
              )
            : null,
        bottomNavigationBar: _BarraNavegacao(
          abaAtiva: _abaAtiva,
          onMudar: _irParaAba,
        ),
      ),
    );
  }
}

// ============================================================================
// BARRA DE NAVEGAÇÃO INFERIOR
// ============================================================================
class _BarraNavegacao extends StatelessWidget {
  final int abaAtiva;
  final ValueChanged<int> onMudar;

  const _BarraNavegacao({required this.abaAtiva, required this.onMudar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10)],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _itemNav(0, Icons.pie_chart_outline, 'Resumo'),
            _itemNav(1, Icons.receipt_long, 'Transações'),
            _itemNav(2, Icons.category_outlined, 'Categorias'),
            _itemNav(3, Icons.bar_chart, 'Relatórios'),
          ],
        ),
      ),
    );
  }

  Widget _itemNav(int index, IconData icone, String titulo) {
    final ativo = abaAtiva == index;
    return Expanded(
      child: InkWell(
        onTap: () => onMudar(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icone, color: ativo ? laranja : textoCinza, size: 26),
              const SizedBox(height: 3),
              Text(
                titulo,
                style: TextStyle(
                  color: ativo ? laranja : textoCinza,
                  fontSize: 11,
                  fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DRAWER (MENU HAMBÚRGUER)
// ============================================================================
class _DrawerMenu extends StatelessWidget {
  final int abaAtiva;
  final ValueChanged<int> onSelecionar;

  const _DrawerMenu({required this.abaAtiva, required this.onSelecionar});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            decoration: const BoxDecoration(
              color: laranja,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: laranja, size: 32),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Seu controle financeiro',
                      style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _itemDrawer(context, 0, Icons.pie_chart_outline, 'Resumo'),
                _itemDrawer(context, 1, Icons.receipt_long, 'Transações'),
                _itemDrawer(context, 2, Icons.category_outlined, 'Categorias'),
                _itemDrawer(context, 3, Icons.bar_chart, 'Relatórios'),
                const Divider(height: 24, indent: 20, endIndent: 20),
                _itemDrawer(context, 4, Icons.settings, 'Configurações'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemDrawer(BuildContext ctx, int index, IconData icone, String titulo) {
    final ativo = abaAtiva == index;
    return ListTile(
      leading: Icon(icone, color: ativo ? laranja : textoCinza),
      title: Text(
        titulo,
        style: TextStyle(
          color: ativo ? laranja : textoPreto,
          fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: ativo,
      selectedTileColor: laranja.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        if (index <= 3) {
          onSelecionar(index);
        } else {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Configurações em breve.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }
}

// ============================================================================
// TELA RESUMO
// ============================================================================
class _ResumoScreen extends StatelessWidget {
  final DateTime mes;
  final double totalReceitas;
  final double totalDespesas;
  final double saldo;
  final List<Transaction> transacoes;
  final ValueChanged<int> onMudarMes;
  final VoidCallback onAdicionar;
  final ValueChanged<Transaction> onEditar;
  final ValueChanged<Transaction> onExcluir;
  final VoidCallback onFiltrar;
  final VoidCallback onVerTodas;

  const _ResumoScreen({
    required this.mes,
    required this.totalReceitas,
    required this.totalDespesas,
    required this.saldo,
    required this.transacoes,
    required this.onMudarMes,
    required this.onAdicionar,
    required this.onEditar,
    required this.onExcluir,
    required this.onFiltrar,
    required this.onVerTodas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoCinza,
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'Finanças',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: onFiltrar,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _cabecalhoMes(context),
            const SizedBox(height: 16),
            _CartaoResumo(
              receitas: totalReceitas,
              despesas: totalDespesas,
              saldo: saldo,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transações',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textoPreto,
                  ),
                ),
TextButton(
                  onPressed: onVerTodas,
                  child: const Text('Ver todas'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (transacoes.isEmpty)
              const _Vazio()
            else
              ...transacoes.take(6).map(
                    (t) => _ItemTransacao(
                      transacao: t,
                      onTap: () => onEditar(t),
                      onExcluir: () => onExcluir(t),
                    ),
),
          ],
        ),
      ),
    );
  }

  Widget _cabecalhoMes(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Resumo do Mês',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 4),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: () => onMudarMes(-1),
              ),
              Text(
                '${nomeMes(mes.month)} / ${mes.year}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textoPreto,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: () => onMudarMes(1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// CARTÃO DE RESUMO FINANCEIRO
// ============================================================================
class _CartaoResumo extends StatelessWidget {
  final double receitas;
  final double despesas;
  final double saldo;

  const _CartaoResumo({
    required this.receitas,
    required this.despesas,
    required this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _colunaValor(
                  'Receitas',
                  formatarMoeda(receitas),
                  verde,
                  Icons.arrow_upward,
                ),
              ),
              Container(width: 1, height: 50, color: fundoCinza),
              Expanded(
                child: _colunaValor(
                  'Despesas',
                  formatarMoeda(despesas),
                  vermelho,
                  Icons.arrow_downward,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: fundoCinza, height: 1),
          const SizedBox(height: 16),
          _colunaValor('Saldo', formatarMoeda(saldo), textoPreto, null),
        ],
      ),
    );
  }

  Widget _colunaValor(String titulo, String valor, Color cor, IconData? icone) {
    return Column(
      children: [
        Text(
          titulo.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textoCinza,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icone != null) ...[
              Icon(icone, color: cor, size: 16),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                valor,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: cor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// ITEM DE TRANSAÇÃO
// ============================================================================
class _ItemTransacao extends StatelessWidget {
  final Transaction transacao;
  final VoidCallback onTap;
  final VoidCallback onExcluir;

  const _ItemTransacao({
    required this.transacao,
    required this.onTap,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final cat = categoriaPorNome(transacao.categoria);
    final receita = transacao.tipo == TipoTransacao.receita;
    final cor = receita ? verde : vermelho;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: cat.cor.withValues(alpha: 0.15),
          child: Icon(cat.icone, color: cat.cor, size: 24),
        ),
        title: Text(
          transacao.descricao,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: textoPreto,
          ),
        ),
        subtitle: Text(
          formatarData(transacao.data),
          style: const TextStyle(fontSize: 12, color: textoCinza),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatarMoeda(transacao.valor),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: cor,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  receita ? Icons.arrow_upward : Icons.arrow_downward,
                  color: cor,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ESTADO VAZIO
// ============================================================================
class _Vazio extends StatelessWidget {
  const _Vazio();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox, size: 48, color: textoCinza),
          SizedBox(height: 12),
          Text(
            'Nenhuma movimentação neste mês.',
            style: TextStyle(color: textoCinza, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TELA TRANSAÇÕES
// ============================================================================
class _TransacoesScreen extends StatelessWidget {
  final List<Transaction> transacoes;
  final String filtroTipo;
  final VoidCallback onAdicionar;
  final ValueChanged<Transaction> onEditar;
  final ValueChanged<Transaction> onExcluir;
  final VoidCallback onFiltrar;

  const _TransacoesScreen({
    required this.transacoes,
    required this.filtroTipo,
    required this.onAdicionar,
    required this.onEditar,
    required this.onExcluir,
    required this.onFiltrar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoCinza,
      appBar: AppBar(
        title: const Text(
          'Transações',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: onFiltrar,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filtroRapido(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${transacoes.length} movimentaç${transacoes.length == 1 ? 'ão' : 'ões'}',
                style: const TextStyle(color: textoCinza, fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: transacoes.isEmpty
                  ? const _Vazio()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: transacoes.length,
                      itemBuilder: (ctx, i) => _ItemTransacao(
                        transacao: transacoes[i],
                        onTap: () => onEditar(transacoes[i]),
                        onExcluir: () => onExcluir(transacoes[i]),
                      ),
                    ),
),
          ],
        ),
      ),
    );
  }

  Widget _filtroRapido() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _chipFiltro('Todas'),
          const SizedBox(width: 8),
          _chipFiltro('Receitas'),
          const SizedBox(width: 8),
          _chipFiltro('Despesas'),
        ],
      ),
    );
  }

  Widget _chipFiltro(String label) {
    final ativo = filtroTipo == label;
    return GestureDetector(
      onTap: onFiltrar,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: ativo ? laranja : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ativo ? laranja : fundoCinza),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ativo ? Colors.white : textoCinza,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// TELA CATEGORIAS
// ============================================================================
class _CategoriasScreen extends StatelessWidget {
  const _CategoriasScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoCinza,
      appBar: AppBar(
        title: const Text(
          'Categorias',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categorias.length,
          itemBuilder: (ctx, i) {
            final c = categorias[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: c.cor.withValues(alpha: 0.15),
                  child: Icon(c.icone, color: c.cor),
                ),
                title: Text(
                  c.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textoPreto,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: textoCinza),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// TELA RELATÓRIOS
// ============================================================================
class _RelatoriosScreen extends StatelessWidget {
  final List<Transaction> transacoesDoMes;
  final DateTime mes;
  final double totalReceitas;
  final double totalDespesas;
  final double saldo;

  const _RelatoriosScreen({
    required this.transacoesDoMes,
    required this.mes,
    required this.totalReceitas,
    required this.totalDespesas,
    required this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    final gastosPorCategoria = <String, double>{};
    for (final t in transacoesDoMes) {
      if (t.tipo == TipoTransacao.despesa) {
        gastosPorCategoria.update(
          t.categoria,
          (v) => v + t.valor,
          ifAbsent: () => t.valor,
        );
      }
    }

    final entrada = gastosPorCategoria.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    double maxGasto = 0;
    for (final e in gastosPorCategoria.values) {
      if (e > maxGasto) maxGasto = e;
    }
    if (maxGasto == 0) maxGasto = 1;

    return Scaffold(
      backgroundColor: fundoCinza,
      appBar: AppBar(
        title: const Text(
          'Relatórios',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Relatório de ${nomeMes(mes.month)} / ${mes.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textoPreto,
              ),
            ),
            const SizedBox(height: 16),
            _CartaoResumo(
              receitas: totalReceitas,
              despesas: totalDespesas,
              saldo: saldo,
            ),
            const SizedBox(height: 24),
            const Text(
              'Gastos por Categoria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textoPreto,
              ),
            ),
            const SizedBox(height: 12),
            if (entrada.isEmpty)
              const _Vazio()
            else ...[
              ...entrada.map((e) {
                final cat = categoriaPorNome(e.key);
                final pct = (e.value / maxGasto).clamp(0.0, 1.0);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            formatarMoeda(e.value),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: vermelho,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Stack(
                        children: [
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: fundoCinza,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: pct,
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: cat.cor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FORMULÁRIO DE TRANSAÇÃO (ADD / EDIT) - BOTTOM SHEET
// ============================================================================
class FormularioTransacao extends StatefulWidget {
  final Transaction? transacaoExistente;
  final List<CategoriaInfo> categorias;

  const FormularioTransacao({
    super.key,
    this.transacaoExistente,
    required this.categorias,
  });

  @override
  State<FormularioTransacao> createState() => _FormularioTransacaoState();
}

class _FormularioTransacaoState extends State<FormularioTransacao> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descricao;
  late final TextEditingController _valor;
  late final TextEditingController _observacao;
  late TipoTransacao _tipo;
  late String _categoria;
  late DateTime _data;

  final _chaveId = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    final t = widget.transacaoExistente;
    _tipo = t?.tipo ?? TipoTransacao.despesa;
    _categoria = t?.categoria ?? (widget.categorias.isNotEmpty ? widget.categorias.first.nome : 'Outros');
    _data = t?.data ?? DateTime.now();
    _descricao = TextEditingController(text: t?.descricao ?? '');
    _valor = TextEditingController(
      text: t != null ? t.valor.toStringAsFixed(2).replaceAll('.', ',') : '',
    );
    _observacao = TextEditingController(text: t?.observacao ?? '');
  }

  @override
  void dispose() {
    _descricao.dispose();
    _valor.dispose();
    _observacao.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final agora = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(agora.year - 10),
      lastDate: DateTime(agora.year + 5),
      helpText: 'Selecione a data',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (escolhida != null) {
      setState(() => _data = escolhida);
    }
  }

  double _parseValor(String texto) {
    var limpo = texto.replaceAll('R\$', '').replaceAll(' ', '').trim();
    limpo = limpo.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(limpo) ?? 0;
  }

  void _salvar() {
    final valor = _parseValor(_valor.text);
    if (_descricao.text.trim().isEmpty) {
      _formKey.currentState?.validate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite uma descrição.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um valor válido.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_categoria.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma categoria.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final nova = Transaction(
      id: widget.transacaoExistente?.id ?? _chaveId,
      descricao: _descricao.text.trim(),
      valor: valor,
      tipo: _tipo,
      categoria: _categoria,
      data: _data,
      observacao: _observacao.text.trim(),
    );

    if (widget.transacaoExistente != null) {
      // Retorna a transação atualizada ao pai.
      Navigator.pop(context, nova);
    } else {
      Navigator.pop(context, nova);
    }
    // Aviso de sucesso é tratado pelo chamador (pai).
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.transacaoExistente != null;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: fundoCinza,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                editando ? 'Editar movimentação' : 'Adicionar movimentação',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textoPreto,
                ),
              ),
              const SizedBox(height: 16),

              // Tipo
              const Text(
                'Tipo',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _botaoTipo('Receita', TipoTransacao.receita, verde),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _botaoTipo('Despesa', TipoTransacao.despesa, vermelho),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Valor
              TextFormField(
                controller: _valor,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                decoration: _decoration('Valor (R\$)', Icons.attach_money),
              ),
              const SizedBox(height: 14),

              // Descrição
              TextFormField(
                controller: _descricao,
                decoration: _decoration('Descrição', Icons.edit),
              ),
              const SizedBox(height: 14),

              // Categoria
              const Text(
                'Categoria',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _selectorCategoria(),
              const SizedBox(height: 14),

              // Data
              InkWell(
                onTap: _selecionarData,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: textoCinza, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        formatarData(_data),
                        style: const TextStyle(fontSize: 15, color: textoPreto),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Observação
              TextFormField(
                controller: _observacao,
                maxLines: 2,
                decoration: _decoration('Observação (opcional)', Icons.notes),
              ),
              const SizedBox(height: 20),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textoCinza,
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: laranja,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icone) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, color: textoCinza),
      filled: true,
      fillColor: fundoCinza,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: laranja, width: 2),
      ),
    );
  }

  Widget _botaoTipo(String label, TipoTransacao tipo, Color cor) {
    final ativo = _tipo == tipo;
    return GestureDetector(
      onTap: () => setState(() => _tipo = tipo),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ativo ? cor.withValues(alpha: 0.12) : fundoCinza,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ativo ? cor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tipo == TipoTransacao.receita
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: ativo ? cor : textoCinza,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ativo ? cor : textoCinza,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectorCategoria() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.categorias.map((c) {
        final ativo = _categoria == c.nome;
        return GestureDetector(
          onTap: () => setState(() => _categoria = c.nome),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ativo ? c.cor.withValues(alpha: 0.15) : fundoCinza,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ativo ? c.cor : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(c.icone, color: c.cor, size: 16),
                const SizedBox(width: 6),
                Text(
                  c.nome,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ativo ? c.cor : textoCinza,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================================
// PAINEL DE FILTROS
// ============================================================================
class _PainelFiltros extends StatefulWidget {
  final String tipo;
  final String? categoria;
  final void Function(String tipo, String? categoria) aoAplicar;

  const _PainelFiltros({
    required this.tipo,
    required this.categoria,
    required this.aoAplicar,
  });

  @override
  State<_PainelFiltros> createState() => _PainelFiltrosState();
}

class _PainelFiltrosState extends State<_PainelFiltros> {
  late String _tipo;
  String? _categoria;

  @override
  void initState() {
    super.initState();
    _tipo = widget.tipo;
    _categoria = widget.categoria;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: fundoCinza,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filtrar transações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textoPreto,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tipo',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Todas', 'Receitas', 'Despesas'].map((tipo) {
                final ativo = _tipo == tipo;
                return GestureDetector(
                  onTap: () => setState(() => _tipo = tipo),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: ativo ? laranja : fundoCinza,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tipo,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ativo ? Colors.white : textoCinza,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Categoria',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categorias.map((c) {
                final ativo = _categoria == c.nome;
                return GestureDetector(
                  onTap: () => setState(() {
                    _categoria = ativo ? null : c.nome;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ativo ? c.cor.withValues(alpha: 0.15) : fundoCinza,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ativo ? c.cor : Colors.transparent),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(c.icone, color: c.cor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          c.nome,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ativo ? c.cor : textoCinza,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _tipo = 'Todas';
                        _categoria = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textoCinza,
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Limpar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.aoAplicar(_tipo, _categoria);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: laranja,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Aplicar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
