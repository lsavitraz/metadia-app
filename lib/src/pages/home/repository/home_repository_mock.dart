import 'package:flutter/material.dart';
import 'package:metadia/src/constants/dias_semana_enum.dart';
import 'package:metadia/src/constants/meta_type_enum.dart';
import 'package:metadia/src/model/atividade_model.dart';
import 'package:metadia/src/model/meta_model.dart';
import 'package:metadia/src/model/registro_diario_model.dart';
import 'package:metadia/src/pages/home/repository/home_repository.dart';

class HomeRepositoryMock implements HomeRepository {
  final List<MetaModel> _metas = [];
  final List<RegistroDiarioModel> _registros = [];

  HomeRepositoryMock() {
    _mockData();
  }

  void _mockData() {
    final metaAtividadeFisica = MetaModel(
      id: 'meta_1',
      nome: 'Atividade Física',
      descricao: 'Manter rotina de exercícios',
      tipo: MetaType.composta,
      objetivoQuantidade: 200,
      dataInicial: DateTime(2026, 1, 1),
      dataFinal: DateTime(2026, 12, 31),
      ativa: true,
      cor: Color(0xFF6FA89A),
      atividades: [
        AtividadeModel(id: 'ativ_1', metaId: 'meta_1', nome: 'Pilates', diasSemana: [DiasSemana.segunda, DiasSemana.quarta], ativa: true, cor: Color(0xFFA7CFC2)),
        AtividadeModel(id: 'ativ_2', metaId: 'meta_1', nome: 'Funcional', diasSemana: [DiasSemana.segunda, DiasSemana.quarta], ativa: true, cor: Color(0xFFA7CFC2)),
      ],
    );

    final metaMeditacao = MetaModel(
      id: 'meta_2',
      nome: 'Meditação',
      descricao: 'Manter a paciência com meu marido!',
      tipo: MetaType.simples,
      objetivoQuantidade: 100,
      dataInicial: DateTime(2026, 1, 1),
      dataFinal: DateTime(2026, 12, 31),
      ativa: true,
      cor: Color(0xFF6FA89A),
      atividades: [
        AtividadeModel(id: 'ativ_3', metaId: 'meta_2', nome: 'Yoga', diasSemana: [DiasSemana.terca, DiasSemana.quarta, DiasSemana.quinta, DiasSemana.sexta], ativa: true, cor: Color(0xFFA7CFC2)),
      ],
    );

    final metaAtividade = MetaModel(
      id: 'meta_3',
      nome: 'Atividade 😏',
      descricao: 'Manter o ritmo!',
      tipo: MetaType.simples,
      objetivoQuantidade: 100,
      dataInicial: DateTime(2026, 1, 1),
      dataFinal: DateTime(2026, 12, 31),
      ativa: true,
      cor: Color(0xFF6FA89A),
      atividades: [AtividadeModel(id: 'ativ_4', metaId: 'meta_3', nome: 'Atividade 😏', ativa: true, cor: Color(0xFFA7CFC2))],
    );

    final metaPasseio = MetaModel(
      id: 'meta_4',
      nome: 'Passeio com cachorro',
      descricao: 'Levar o cachorro para passear',
      tipo: MetaType.acumulativa,
      objetivoQuantidade: 31,
      dataInicial: DateTime(2026, 3, 1),
      dataFinal: DateTime(2026, 3, 31),
      ativa: true,
      cor: Color(0xFF6FA89A),
      atividades: [AtividadeModel(id: 'ativ_5', metaId: 'meta_4', nome: 'Passeio com cachorro', ativa: true, cor: Color(0xFFA7CFC2))],
    );

    _metas.addAll([metaAtividadeFisica, metaMeditacao, metaAtividade, metaPasseio]);
  }

  @override
  Future<List<MetaModel>> getMetasAtivas() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _metas.where((meta) => meta.ativa).toList();
  }

  @override
  Future<List<RegistroDiarioModel>> getRegistrosByDate(DateTime dia) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return _registros.where((registro) {
      return registro.data.year == dia.year && registro.data.month == dia.month && registro.data.day == dia.day;
    }).toList();
  }

  @override
  Future<void> registrarAtividade({required DateTime data, required String metaId, required String atividadeId}) async {
    await Future.delayed(const Duration(milliseconds: 150));

    //Encontrar a meta
    final meta = _metas.firstWhere((m) => m.id == metaId);

    // Procurar registro existente no mesmo dia
    final registroExistente = _registros.where((registro) {
      return registro.metaId == metaId && registro.atividadeId == atividadeId && registro.data.year == data.year && registro.data.month == data.month && registro.data.day == data.day;
    }).toList();

    if (meta.tipo == MetaType.acumulativa) {
      //Se ja existe, incrementa a quantidade
      if (registroExistente.isNotEmpty) {
        registroExistente.first.quantidade += 1;
      } else {
        //Se não existe, cria novo registro com quantidade 1
        _registros.add(RegistroDiarioModel(id: _registros.length + 1, data: data, metaId: metaId, atividadeId: atividadeId, quantidade: 1));
      }
    } else {
      //Para simples e composta, só registra se ainda não existe
      if (registroExistente.isEmpty) {
        _registros.add(RegistroDiarioModel(id: _registros.length + 1, data: data, metaId: metaId, atividadeId: atividadeId, quantidade: 1));
      }
    }
  }

  Future<void> decrementarAtividade({required DateTime data, required String metaId, required String atividadeId}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    // Procurar registro existente no mesmo dia
    final registroExistente = _registros.where((registro) {
      return registro.metaId == metaId && registro.atividadeId == atividadeId && registro.data.year == data.year && registro.data.month == data.month && registro.data.day == data.day;
    }).toList();

    if (registroExistente.isNotEmpty) {
      final registro = registroExistente.first;
      if (registro.quantidade > 1) {
        registro.quantidade -= 1;
      } else {
        _registros.remove(registro);
      }
    }
  }

  @override
  Future<void> salvarMeta(MetaModel meta) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _metas.add(meta);
  }
  
}
