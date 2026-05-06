import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../utils/db_util.dart';

class TarefasProvider extends ChangeNotifier {
  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => _tarefas;

  Tarefa? get proximaTarefa {
    final pendentes = _tarefas.where((t) => !t.realizada).toList();
    if (pendentes.isEmpty) return null;
    pendentes.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    return pendentes.first;
  }

  Future<void> carregarTarefas() async {
    final lista = await DBUtil.list('Tarefa', orderBy: 'data_prevista ASC');
    _tarefas = lista.map((map) => Tarefa.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> adicionarTarefa(Tarefa tarefa) async {
    final id = await DBUtil.insert('Tarefa', tarefa.toMap());
    tarefa.id = id;
    _tarefas.add(tarefa);
    _tarefas.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    notifyListeners();
  }

  Future<void> atualizarTarefa(Tarefa tarefa) async {
    await DBUtil.update('Tarefa', tarefa.toMap());
    final index = _tarefas.indexWhere((t) => t.id == tarefa.id);
    if (index != -1) _tarefas[index] = tarefa;
    _tarefas.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    notifyListeners();
  }

  Future<void> alternarRealizada(Tarefa tarefa) async {
    tarefa.realizada = !tarefa.realizada;
    await atualizarTarefa(tarefa);
  }

  Future<void> deletarTarefa(int id) async {
    await DBUtil.delete('Tarefa', id);
    _tarefas.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
