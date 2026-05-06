import 'package:flutter/material.dart';
import '../models/etiqueta.dart';
import '../utils/db_util.dart';

class EtiquetasProvider extends ChangeNotifier {
  List<Etiqueta> _etiquetas = [];

  List<Etiqueta> get etiquetas => _etiquetas;

  Etiqueta? buscarPorId(int? id) {
    if (id == null) return null;
    try {
      return _etiquetas.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> carregarEtiquetas() async {
    final lista = await DBUtil.list('Etiqueta', orderBy: 'titulo ASC');
    _etiquetas = lista.map((map) => Etiqueta.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> adicionarEtiqueta(Etiqueta etiqueta) async {
    final id = await DBUtil.insert('Etiqueta', etiqueta.toMap());
    etiqueta.id = id;
    _etiquetas.add(etiqueta);
    notifyListeners();
  }

  Future<void> atualizarEtiqueta(Etiqueta etiqueta) async {
    await DBUtil.update('Etiqueta', etiqueta.toMap());
    final index = _etiquetas.indexWhere((e) => e.id == etiqueta.id);
    if (index != -1) _etiquetas[index] = etiqueta;
    notifyListeners();
  }

  Future<void> deletarEtiqueta(int id) async {
    await DBUtil.delete('Etiqueta', id);
    _etiquetas.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
