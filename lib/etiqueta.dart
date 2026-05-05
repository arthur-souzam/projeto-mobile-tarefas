class Etiqueta {
  int? id;
  String titulo;
  int cor;

  Etiqueta({
    this.id,
    required this.titulo,
    required this.cor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'cor': cor,
    };
  }

  factory Etiqueta.fromMap(Map<String, dynamic> map) {
    return Etiqueta(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      cor: map['cor'] as int,
    );
  }
}
