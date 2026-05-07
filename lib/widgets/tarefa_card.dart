import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../models/etiqueta.dart';
import '../utils/rotas.dart';
import '../providers/tarefas_provider.dart';
import 'package:provider/provider.dart';

class TarefaCard extends StatelessWidget {
  final Tarefa tarefa;
  final Etiqueta? etiqueta;

  const TarefaCard({
    super.key,
    required this.tarefa,
    this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final dataPrevista = DateTime.tryParse(tarefa.dataPrevista);
    final atrasada = dataPrevista != null &&
        dataPrevista.isBefore(DateTime(hoje.year, hoje.month, hoje.day)) &&
        !tarefa.realizada;

    return Card(
      shape: etiqueta != null
          ? RoundedRectangleBorder(
              side: BorderSide(color: Color(etiqueta!.cor), width: 4),
              borderRadius: BorderRadius.circular(8),
            )
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
                leading: GestureDetector(
            onTap: () {
              tarefa.importante = !tarefa.importante;
              context.read<TarefasProvider>().atualizarTarefa(tarefa);
            },
            child: tarefa.importante
                ? const Icon(Icons.star, color: Colors.amber)
                : const Icon(Icons.star_border, color: Colors.grey),
          ),
        title: Text(
          tarefa.titulo,
          style: TextStyle(
            decoration: tarefa.realizada ? TextDecoration.lineThrough : null,
            color: tarefa.realizada ? Colors.grey : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 12, color: atrasada ? Colors.red : Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatarData(tarefa.dataPrevista),
                  style: TextStyle(
                    color: atrasada ? Colors.red : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (atrasada) ...[
                  const SizedBox(width: 6),
                  const Text('ATRASADA',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ],
            ),
            if (etiqueta != null) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(etiqueta!.cor).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(etiqueta!.cor)),
                ),
                child: Text(
                  etiqueta!.titulo,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(etiqueta!.cor),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Checkbox(
          value: tarefa.realizada,
          onChanged: (_) {
            context.read<TarefasProvider>().alternarRealizada(tarefa);
          },
        ),
        onTap: () {
          Navigator.pushNamed(context, Rotas.detalhesTarefa,
              arguments: tarefa);
        },
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
