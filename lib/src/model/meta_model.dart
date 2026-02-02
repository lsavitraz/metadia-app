import 'package:flutter/material.dart';
import 'package:metadia/src/constants/meta_type_enum.dart';
import 'package:metadia/src/model/atividade_model.dart';

class MetaModel {
  final String id; //UUID
  String nome;
  String descricao;
  MetaType tipo;
  int objetivoQuantidade;
  List<AtividadeModel> atividades;
  DateTime dataInicial;
  DateTime dataFinal;
  bool ativa;
  DateTime? arquivadaEm;
  Color cor;

  MetaModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.objetivoQuantidade,
    required this.atividades,
    required this.dataInicial,
    required this.dataFinal,
    required this.ativa,
    this.arquivadaEm,
    required this.cor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo.nome,
      'objetivoQuantidade': objetivoQuantidade,
      'atividades': atividades.map((atividade) => atividade.toMap()).toList(),
      'dataInicial': dataInicial.toIso8601String(),
      'dataFinal': dataFinal.toIso8601String(),
      'ativa': ativa,
      'arquivadaEm': arquivadaEm?.toIso8601String(),
      'cor': cor.value,
      };
  }

  factory MetaModel.fromMap(Map<String, dynamic> map) {
    return MetaModel(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      tipo: MetaType.fromName(map['tipo']),
      objetivoQuantidade: map['objetivoQuantidade'],
      atividades: List<AtividadeModel>.from(map['atividades']?.map((atividade) => AtividadeModel.fromMap(atividade))),
      dataInicial: DateTime.parse(map['dataInicial']),
      dataFinal: DateTime.parse(map['dataFinal']),
      ativa: map['ativa'],
      arquivadaEm: map['arquivadaEm'] != null ? DateTime.parse(map['arquivadaEm']) : null,
      cor: Color(map['cor']),
      );
  }

  @override
  String toString() {
    return 'MetaModel(id: $id, nome: $nome, descricao: $descricao, tipo: $tipo, objetivoQuantidade: $objetivoQuantidade, atividades: $atividades, dataInicial: $dataInicial, dataFinal: $dataFinal, ativa: $ativa, arquivadaEm: $arquivadaEm, cor: $cor)';
  }
}
