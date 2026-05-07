import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tarefas_provider.dart';
import '../utils/rotas.dart';

class TelaBoasVindas extends StatefulWidget {
  const TelaBoasVindas({super.key});

  @override
  State<TelaBoasVindas> createState() => _TelaBoasVindasState();
}

class _TelaBoasVindasState extends State<TelaBoasVindas> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TarefasProvider>().carregarTarefas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarefasProvider>();
    final proxima = provider.proximaTarefa;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 80, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Minhas Tarefas',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Organize sua vida com simplicidade',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (proxima != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('⏰ Mais próxima de vencer:',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(
                        proxima.titulo,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prevista para: ${_formatarData(proxima.dataPrevista)}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ] else ...[
                const Text('Sem tarefas pendentes!',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 32),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Rotas.listagem),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Iniciar',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
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
