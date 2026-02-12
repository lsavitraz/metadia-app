class RegistroDiarioModel {
  int id;
  DateTime data;
  String metaId;
  String atividadeId;
  int quantidade;

  RegistroDiarioModel({required this.id, required this.data, required this.metaId, required this.atividadeId, this.quantidade = 1});
  
  Map<String, dynamic> toMap() {
    return {'id': id, 'data': data.toIso8601String(), 'metaId': metaId, 'atividadeId': atividadeId, 'quantidade': quantidade};
  }

  factory RegistroDiarioModel.fromMap(Map<String, dynamic> map) {
    return RegistroDiarioModel(id: map['id'], data: DateTime.parse(map['data']), metaId: map['metaId'], atividadeId: map['atividadeId'], quantidade: map['quantidade'] ?? 1);
  }

  @override
  String toString() {
    return 'RegistroDiarioModel(id: $id, data: $data, metaId: $metaId, atividadeId: $atividadeId, quantidade: $quantidade)';
  }
}
