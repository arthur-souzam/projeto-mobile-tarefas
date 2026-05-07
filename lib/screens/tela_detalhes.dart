import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tarefa.dart';
import '../providers/tarefas_provider.dart';
import '../providers/etiquetas_provider.dart';
import '../utils/rotas.dart';
import '../widgets/botao_primario.dart';

class TelaDetalhes extends StatelessWidget {
  const TelaDetalhes({super.key});

  @override
  Widget build(BuildContext context) {
    final tarefa = ModalRoute.of(context)!.settings.arguments as Tarefa;
    final etiquetasProvider = context.watch<EtiquetasProvider>();
    final etiqueta = etiquetasProvider.buscarPorId(tarefa.etiquetaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () async {
              await Navigator.pushNamed(context, Rotas.editarTarefa,
                  arguments: tarefa);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Excluir',
            onPressed: () => _confirmarDelecao(context, tarefa),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tarefa.titulo,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: tarefa.realizada
                        ? TextDecoration.lineThrough
                        : null,
                  ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildLinha('ID', '#${tarefa.id}', Icons.tag),
                    const Divider(),
                    _buildLinha(
                        'Descrição', tarefa.descricao, Icons.description),
                    const Divider(),
                    _buildLinha('Data Prevista',
                        _formatarData(tarefa.dataPrevista), Icons.calendar_today),
                    const Divider(),
                    _buildLinha('Importante',
                        tarefa.importante ? 'Sim ⭐' : 'Não', Icons.star),
                    const Divider(),
                    _buildLinha(
                        'Situação',
                        tarefa.realizada ? 'Realizada ✅' : 'Pendente ⏳',
                        Icons.check_circle_outline),
                    if (etiqueta != null) ...[
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.label, size: 20),
                          const SizedBox(width: 8),
                          const Text('Etiqueta:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(etiqueta.cor).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(etiqueta.cor)),
                            ),
                            child: Text(
                              etiqueta.titulo,
                              style: TextStyle(
                                  color: Color(etiqueta.cor),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (!tarefa.realizada)
              SizedBox(
                width: double.infinity,
                child: BotaoPrimario(
                  texto: 'Marcar como Realizada',
                  icone: Icons.check,
                  cor: Colors.green,
                  onPressed: () async {
                    await context
                        .read<TarefasProvider>()
                        .alternarRealizada(tarefa);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinha(String label, String valor, IconData icone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }

  void _confirmarDelecao(BuildContext context, Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Tarefa'),
        content: Text('Deseja excluir "${tarefa.titulo}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await context
                  .read<TarefasProvider>()
                  .deletarTarefa(tarefa.id!);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) Navigator.pop(context);
            },
            child:
                const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatarData(String data) {
    try {
      final partes = data.split('-');
      return '${partes[2]}/${partes[1]}/${partes[0]}';
    } catch (_) {
      return data;
    }
  }
}
