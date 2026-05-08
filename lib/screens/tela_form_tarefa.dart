import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tarefa.dart';
import '../providers/tarefas_provider.dart';
import '../providers/etiquetas_provider.dart';
import '../widgets/botao_primario.dart';

class TelaFormTarefa extends StatefulWidget {
  final Tarefa? tarefaParaEditar;

  const TelaFormTarefa({super.key, this.tarefaParaEditar});

  @override
  State<TelaFormTarefa> createState() => _TelaFormTarefaState();
}

class _TelaFormTarefaState extends State<TelaFormTarefa> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloCtrl;
  late TextEditingController _descricaoCtrl;

  DateTime? _dataSelecionada;
  bool _importante = false;
  int? _etiquetaIdSelecionada;

  bool get _editando => widget.tarefaParaEditar != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tarefaParaEditar;
    _tituloCtrl = TextEditingController(text: t?.titulo ?? '');
    _descricaoCtrl = TextEditingController(text: t?.descricao ?? '');
    _importante = t?.importante ?? false;
    _etiquetaIdSelecionada = t?.etiquetaId;
    if (t?.dataPrevista != null) {
      _dataSelecionada = DateTime.tryParse(t!.dataPrevista);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EtiquetasProvider>().carregarEtiquetas();
    });
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final etiquetasProvider = context.watch<EtiquetasProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O título é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descrição *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'A descrição é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _abrirSeletorData,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data Prevista *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _dataSelecionada != null
                        ? '${_dataSelecionada!.day.toString().padLeft(2, '0')}/${_dataSelecionada!.month.toString().padLeft(2, '0')}/${_dataSelecionada!.year}'
                        : 'Toque para selecionar a data',
                    style: TextStyle(
                      color: _dataSelecionada != null
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: SwitchListTile(
                  title: const Text('Importante'),
                  subtitle: const Text('Marca a tarefa como prioritária'),
                  secondary: const Icon(Icons.star, color: Colors.amber),
                  value: _importante,
                  onChanged: (val) => setState(() => _importante = val),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                initialValue: _etiquetaIdSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Etiqueta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                hint: const Text('Sem etiqueta'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Sem etiqueta'),
                  ),
                  ...etiquetasProvider.etiquetas.map((e) {
                    return DropdownMenuItem<int?>(
                      value: e.id,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Color(e.cor),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(e.titulo),
                        ],
                      ),
                    );
                  }),
                ],
                onChanged: (val) =>
                    setState(() => _etiquetaIdSelecionada = val),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: BotaoPrimario(
                  texto: _editando ? 'Salvar Alterações' : 'Cadastrar Tarefa',
                  icone: _editando ? Icons.save : Icons.add,
                  onPressed: _salvar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _abrirSeletorData() async {
    final hoje = DateTime.now();
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? hoje,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );
    if (selecionada != null) {
      setState(() => _dataSelecionada = selecionada);
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma data prevista')),
      );
      return;
    }

    final dataFormatada =
        '${_dataSelecionada!.year}-${_dataSelecionada!.month.toString().padLeft(2, '0')}-${_dataSelecionada!.day.toString().padLeft(2, '0')}';

    if (_editando) {
      final t = widget.tarefaParaEditar!;
      t.titulo = _tituloCtrl.text.trim();
      t.descricao = _descricaoCtrl.text.trim();
      t.dataPrevista = dataFormatada;
      t.importante = _importante;
      t.etiquetaId = _etiquetaIdSelecionada;
      await context.read<TarefasProvider>().atualizarTarefa(t);
    } else {
      final nova = Tarefa(
        titulo: _tituloCtrl.text.trim(),
        descricao: _descricaoCtrl.text.trim(),
        dataPrevista: dataFormatada,
        importante: _importante,
        etiquetaId: _etiquetaIdSelecionada,
      );
      await context.read<TarefasProvider>().adicionarTarefa(nova);
    }

    if (mounted) Navigator.pop(context);
  }
}
