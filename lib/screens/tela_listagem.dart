import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tarefa.dart';
import '../providers/tarefas_provider.dart';
import '../providers/etiquetas_provider.dart';
import '../widgets/tarefa_card.dart';
import '../utils/rotas.dart';

class TelaListagem extends StatefulWidget {
  const TelaListagem({super.key});

  @override
  State<TelaListagem> createState() => _TelaListagemState();
}

class _TelaListagemState extends State<TelaListagem>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TarefasProvider>().carregarTarefas();
      context.read<EtiquetasProvider>().carregarEtiquetas();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.label),
            tooltip: 'Gerenciar Etiquetas',
            onPressed: () async {
              await Navigator.pushNamed(context, Rotas.etiquetas);
              if (mounted) {
                context.read<EtiquetasProvider>().carregarEtiquetas();
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Importantes'),
            Tab(text: 'Realizadas'),
            Tab(text: 'Atrasadas'),
          ],
        ),
      ),
      body: Consumer2<TarefasProvider, EtiquetasProvider>(
        builder: (context, tarefasProvider, etiquetasProvider, _) {
          final todas = tarefasProvider.tarefas;
          final hoje = DateTime.now();

          final importantes = todas.where((t) => t.importante).toList();
          final realizadas = todas.where((t) => t.realizada).toList();
          final atrasadas = todas.where((t) {
            final data = DateTime.tryParse(t.dataPrevista);
            return data != null &&
                data.isBefore(
                    DateTime(hoje.year, hoje.month, hoje.day)) &&
                !t.realizada;
          }).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildLista(todas, etiquetasProvider),
              _buildLista(importantes, etiquetasProvider),
              _buildLista(realizadas, etiquetasProvider),
              _buildLista(atrasadas, etiquetasProvider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, Rotas.inserirTarefa);
          if (mounted) context.read<TarefasProvider>().carregarTarefas();
        },
        tooltip: 'Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLista(
      List<Tarefa> tarefas, EtiquetasProvider etiquetasProvider) {
    if (tarefas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhuma tarefa aqui',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];
        final etiqueta = etiquetasProvider.buscarPorId(tarefa.etiquetaId);
        return TarefaCard(tarefa: tarefa, etiqueta: etiqueta);
      },
    );
  }
}
