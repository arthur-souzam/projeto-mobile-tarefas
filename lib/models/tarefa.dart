class Tarefa {
  int? id;
  String titulo;
  String descricao;
  String dataPrevista;
  bool importante;
  bool realizada;
  int? etiquetaId;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataPrevista,
    this.importante = false,
    this.realizada = false,
    this.etiquetaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data_prevista': dataPrevista,
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0,
      'etiqueta_id': etiquetaId,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      dataPrevista: map['data_prevista'] as String,
      importante: (map['importante'] as int) == 1,
      realizada: (map['realizada'] as int) == 1,
      etiquetaId: map['etiqueta_id'] as int?,
    );
  }
}
