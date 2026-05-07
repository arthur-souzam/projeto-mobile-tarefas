import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/etiqueta.dart';
import '../providers/etiquetas_provider.dart';

class TelaEtiquetas extends StatefulWidget {
  const TelaEtiquetas({super.key});

  @override
  State<TelaEtiquetas> createState() => _TelaEtiquetasState();
}

class _TelaEtiquetasState extends State<TelaEtiquetas> {
  static const List<int> _coresPaleta = [
    0xFFE53935,
    0xFFE91E63,
    0xFF9C27B0,
    0xFF3F51B5,
    0xFF2196F3,
    0xFF00BCD4,
    0xFF4CAF50,
    0xFF8BC34A,
    0xFFFFEB3B,
    0xFFFF9800,
    0xFF795548,
    0xFF607D8B,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EtiquetasProvider>().carregarEtiquetas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Etiquetas')),
      body: Consumer<EtiquetasProvider>(
        builder: (context, provider, _) {
          if (provider.etiquetas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.label_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhuma etiqueta criada',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Toque no + para adicionar',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.etiquetas.length,
            itemBuilder: (context, index) {
              final etiqueta = provider.etiquetas[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(etiqueta.cor),
                  radius: 16,
                ),
                title: Text(etiqueta.titulo),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmarDelecao(context, etiqueta),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirDialogNova(context),
        tooltip: 'Nova Etiqueta',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _abrirDialogNova(BuildContext context) {
    final ctrl = TextEditingController();
    int corSelecionada = _coresPaleta[0];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nova Etiqueta'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      labelText: 'Nome da etiqueta',
                      border: OutlineInputBorder(),
                      hintText: 'Ex: Urgente, Trabalho...',
                    ),
                    autofocus: true,
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 16),
                  const Text('Escolha uma cor:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _coresPaleta.map((cor) {
                      final selecionada = cor == corSelecionada;
                      return GestureDetector(
                        onTap: () =>
                            setDialogState(() => corSelecionada = cor),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(cor),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selecionada
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: selecionada
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Preview: '),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(corSelecionada).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color(corSelecionada)),
                        ),
                        child: Text(
                          ctrl.text.isEmpty ? 'Etiqueta' : ctrl.text,
                          style: TextStyle(
                              color: Color(corSelecionada),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final titulo = ctrl.text.trim();
                    if (titulo.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Digite um nome para a etiqueta')),
                      );
                      return;
                    }
                    final nova =
                        Etiqueta(titulo: titulo, cor: corSelecionada);
                    await context
                        .read<EtiquetasProvider>()
                        .adicionarEtiqueta(nova);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Criar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmarDelecao(BuildContext context, Etiqueta etiqueta) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Etiqueta'),
        content: Text(
            'Excluir "${etiqueta.titulo}"? As tarefas com essa etiqueta ficarão sem etiqueta.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await context
                  .read<EtiquetasProvider>()
                  .deletarEtiqueta(etiqueta.id!);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child:
                const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
