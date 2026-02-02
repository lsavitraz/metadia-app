import 'package:flutter/material.dart';
import 'package:metadia/src/constants/dias_semana_enum.dart';

class AtividadeModel {
  final String id;
  final String metaId;
  String nome;
  List<DiasSemana>? diasSemana;
  bool ativa;
  Color cor;

  AtividadeModel({
    required this.id,
    required this.metaId,
    required this.nome,
    this.diasSemana,
    required this.ativa,
    required this.cor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'metaId': metaId,
      'nome': nome,
      'diasSemana': diasSemana?.map((dia) => dia.id).toList(),
      'ativa': ativa,
      'cor': cor.value,
    };
  }

  factory AtividadeModel.fromMap(Map<String, dynamic> map) {
    return AtividadeModel(
      id: map['id'],
      metaId: map['metaId'],
      nome: map['nome'],
      diasSemana: map['diasSemana'] != null 
        ? (map['diasSemana'] as List)
            .map((id) => DiasSemana.fromId(id))
            .toList()
        : null,
      ativa: map['ativa'],
      cor: Color(map['cor']),
    );
  }

  @override
  String toString() {
    return 'AtividadeModel(id: $id, metaId: $metaId, nome: $nome, diasSemana: $diasSemana, ativa: $ativa, cor: $cor)';
  } 

}
