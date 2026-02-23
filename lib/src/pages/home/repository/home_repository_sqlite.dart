import 'package:flutter/material.dart';
import 'package:metadia/src/constants/dias_semana_enum.dart';
import 'package:metadia/src/constants/meta_type_enum.dart';
import 'package:metadia/src/database/database_helper.dart';
import 'package:metadia/src/model/atividade_model.dart';
import 'package:metadia/src/model/meta_model.dart';
import 'package:metadia/src/model/registro_diario_model.dart';
import 'package:metadia/src/pages/home/repository/home_repository.dart';

class HomeRepositorySqlite implements HomeRepository {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<void> salvarMeta(MetaModel meta) async {
    final db = await dbHelper.database;

    await db.insert('metas', {
      'id': meta.id,
      'nome': meta.nome,
      'descricao': meta.descricao,
      'tipo': meta.tipo.nome,
      'objetivoQuantidade': meta.objetivoQuantidade,
      'dataInicial': meta.dataInicial.toIso8601String(),
      'dataFinal': meta.dataFinal.toIso8601String(),
      'ativa': meta.ativa ? 1 : 0,
      'cor': meta.cor.toARGB32(),
    });

    for (var atividade in meta.atividades){
      await db.insert('atividades', {
        'id': atividade.id,
        'metaId': atividade.metaId,
        'nome': atividade.nome,
        'ativa': atividade.ativa ? 1 : 0,
        'cor': atividade.cor.toARGB32(),
      });
    
      if(atividade.diasSemana != null){
        for(var dia in atividade.diasSemana!){
          await db.insert('atividade_dias', {
            'atividadeId': atividade.id,
            'diaSemana': dia.id,
          });
        }
      }
    }
  }

  @override
  Future<List<MetaModel>> getMetasAtivas() async {
    final db = await dbHelper.database;

    final metasMap = await db.query(
      'metas',
      where: 'ativa = ?',
      whereArgs: [1],
    );

    List<MetaModel> metas = [];

    for(var metaMap in metasMap){
      final atividadesMap = await db.query(
        'atividades',
        where: 'metaId = ?',
        whereArgs: [metaMap['id']],
      );

      List<AtividadeModel> atividades = [];

      for(var atividadeMap in atividadesMap){
        final diasMap = await db.query(
          'atividade_dias',
          where: 'atividadeId = ?',
          whereArgs: [atividadeMap['id']],
        );

        final dias = diasMap
          .map((d) => d['diaSemana'] as int)
          .map((id) => DiasSemana.fromId(id))
          .toList();

          atividades.add(
            AtividadeModel(
              id: atividadeMap['id'] as String,
              metaId: atividadeMap['metaId'] as String,
              nome: atividadeMap['nome'] as String,
              ativa: (atividadeMap['ativa'] as int) == 1,
              cor: Color(atividadeMap['cor'] as int),
              diasSemana: dias.isEmpty ? null : dias,
            ),
          );
      }

      metas.add(
        MetaModel(
          id: metaMap['id'] as String,
          nome: metaMap['nome'] as String,
          descricao: metaMap['descricao'] as String,
          tipo: MetaType.fromName(metaMap['tipo'] as String),
          objetivoQuantidade: metaMap['objetivoQuantidade'] == null ? 0 : metaMap['objetivoQuantidade'] as int,
          atividades: atividades,
          dataInicial: DateTime.parse(metaMap['dataInicial'] as String),
          dataFinal: DateTime.parse(metaMap['dataFinal'] as String),
          ativa: (metaMap['ativa'] as int) == 1,
          cor: Color(metaMap['cor'] as int),
        ),
      );
    }

    return metas;
  }

  @override
  Future<List<RegistroDiarioModel>> getRegistrosByDate(DateTime dia) async {
    final db = await dbHelper.database;

    final normalized = DateTime(dia.year, dia.month, dia.day);
    
    final registrosMap = await db.query(
      'registros',
      where: 'data = ?',
      whereArgs: [normalized.toIso8601String()],
    );

    return registrosMap.map((map) {
      return RegistroDiarioModel(
        id: map['id'] as int,
        data: DateTime.parse(map['data'] as String),
        metaId: map['metaId'] as String,
        atividadeId: map['atividadeId'] as String,
        quantidade: map['quantidade'] as int,
      );
    }).toList();
  }

  @override
  Future<void> registrarAtividade({
    required DateTime data,
    required String metaId,
    required String atividadeId,
    int quantidade = 1,
  }) async {
    final db = await dbHelper.database;

    final normalized = DateTime(data.year, data.month, data.day);

    //Buscar tipo da meta
    final metaMap = await db.query(
      'metas',
      where: 'id = ?',
      whereArgs: [metaId],
    );

    if(metaMap.isEmpty) return; //Meta não encontrada

    final tipo = metaMap.first['tipo'] as String;

    //Buscar registros da MESMA ATIVIDADE NO MESMO DIA
    final existing = await db.query(
      'registros',
      where: '''
        date(data) = date(?) AND 
        metaId = ? AND 
        atividadeId = ?
       ''',
      whereArgs: [
        normalized.toIso8601String(), 
        metaId, 
        atividadeId
      ],
    );

    //META ACUMULATIVA - INCREMENTA QUANTIDADE
    if(tipo == MetaType.acumulativa.nome){
      if(existing.isEmpty){ // Se não existe registro, cria um novo
        await db.insert(
          'registros', 
          {
            'data': normalized.toIso8601String(),
            'metaId': metaId,
            'atividadeId': atividadeId,
            'quantidade': quantidade,
          }  
        );
      } else { // Se já existe registro, atualiza quantidade
        final registro = existing.first;
        final quantidadeAtual = registro['quantidade'] as int;

        await db.update(
          'registros', 
          {'quantidade': quantidadeAtual + quantidade},
          where: 'id = ?',
          whereArgs: [registro['id']],
        );
      }

      return;
    } else { //META SIMPLES E META COMPOSTA - TOGGLE NA ATIVIDADE (REGISTRA OU REMOVE)
      if(existing.isEmpty){ // Se não existe registro, cria um novo
        await db.insert(
          'registros', 
          {
            'data': normalized.toIso8601String(),
            'metaId': metaId,
            'atividadeId': atividadeId,
            'quantidade': 1,
          }  
        );
      } else { // Se já existe registro, remove (toggle)
        await db.delete(
          'registros',
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      }
    }
  }

  @override
  Future<void> decrementarAtividade({
    required DateTime data,
    required String metaId,
    required String atividadeId,
  }) async {
    final db = await dbHelper.database;

    final normalized = DateTime(data.year, data.month, data.day);

    final existing = await db.query(
      'registros',
      where: 'date(data) = date(?) AND metaId = ? AND atividadeId = ?',
      whereArgs: [
        normalized.toIso8601String(), 
        metaId, 
        atividadeId],
    );

    if(existing.isEmpty) return; //Nada para decrementar

    final registro = existing.first;
    final quantidadeAtual = registro['quantidade'] as int;

    if(quantidadeAtual > 1){
      await db.update(
        'registros', 
        {'quantidade': quantidadeAtual -1},
        where: 'id = ?',
        whereArgs: [registro['id']],
        );
    } else {
      await db.delete(
        'registros',
        where: 'id = ?',
        whereArgs: [registro['id']],
      );
    }
  }

  @override
  Future<int> getTotalMeta(String metaId) async {
    final db = await dbHelper.database;

    //Buscar tipo de meta
    final metaMap = await db.query(
      'metas',
      where: 'id = ?',
      whereArgs: [metaId],
    );

    if(metaMap.isEmpty) return 0; //Meta não encontrada

    final tipo = metaMap.first['tipo'] as String;

    //META ACUMULTIVA - SOMA QUANTIDADES
    if(tipo == MetaType.acumulativa.nome){
      final result = await db.rawQuery('''
        SELECT SUM(quantidade) as total
        FROM registros
        WHERE metaId = ?
        ''',
        [metaId]);

        final total = result.first['total'];
        return total == null ? 0 : total as int;
    }

    // META COMPOSTA - CONTA REGISTROS DE ATIVIDADES POR DIA DISTINTO
    if(tipo == MetaType.composta.nome){
      final result = await db.rawQuery('''
        SELECT COUNT(DISTINCT date(data)) as total
        FROM registros
        WHERE metaId = ?
        ''',
        [metaId]);

        final total = result.first['total'];
        return total == null ? 0 : total as int;
    }

    //META SIMPLES - CONTA REGISTROS
    final result = await db.rawQuery('''
      SELECT COUNT(*) as total
      FROM registros
      WHERE metaId = ?
      ''',
      [metaId]);

      final total = result.first['total'];
      return total == null ? 0 : total as int;
  }

  @override
  Future<void> inativarMeta(String metaId) async {
    final db = await dbHelper.database;

    //Inativa a meta
    await db.update(
      'metas', 
      {'ativa': 0},
      where: 'id = ?',
      whereArgs: [metaId],
    );
  }

  @override
  Future<MetaModel> getMetaById(String metaId) async {
    final db = await dbHelper.database;

    final metasMap = await db.query(
      'metas',
      where: 'id = ?',
      whereArgs: [metaId],
    );

    if (metasMap.isEmpty) {
      throw Exception('Meta não encontrada');
    }

    final metaMap = metasMap.first;

    final atividadesMap = await db.query(
      'atividades',
      where: 'metaId = ?',
      whereArgs: [metaId],
    );

    List<AtividadeModel> atividades = [];

    for (final atividadeMap in atividadesMap) {
      final atividadeId = atividadeMap['id'] as String;

      final diasMap = await db.query(
        'atividade_dias',
        where: 'atividadeId = ?',
        whereArgs: [atividadeId],
      );

      final dias = diasMap.map((dia) {
        return DiasSemana.fromId(dia['diaSemana'] as int);
      }).toList();

      atividades.add(
        AtividadeModel(
          id: atividadeId,
          metaId: atividadeMap['metaId'] as String,
          nome: atividadeMap['nome'] as String,
          ativa: (atividadeMap['ativa'] as int) == 1,
          cor: Color(atividadeMap['cor'] as int),
          diasSemana: dias.isEmpty ? null : dias,
        ),
      );
    }

    return MetaModel(
      id: metaMap['id'] as String,
      nome: metaMap['nome'] as String,
      descricao: metaMap['descricao'] as String,
      tipo: MetaType.values.firstWhere(
        (e) => e.nome == metaMap['tipo'],
      ),
      objetivoQuantidade: metaMap['objetivoQuantidade'] as int,
      dataInicial: DateTime.parse(metaMap['dataInicial'] as String),
      dataFinal: DateTime.parse(metaMap['dataFinal'] as String),
      ativa: (metaMap['ativa'] as int) == 1,
      cor: Color(metaMap['cor'] as int),
      atividades: atividades,
    );
  }

  @override
  Future<void> updateMeta(MetaModel meta) async {
    final db = await dbHelper.database;

    await db.transaction((txn) async {

      //Atualiza meta
      await txn.update(
        'metas',
        {
          'nome': meta.nome,
          'descricao': meta.descricao,
          'tipo': meta.tipo.nome,
          'objetivoQuantidade': meta.objetivoQuantidade,
          'dataInicial': meta.dataInicial.toIso8601String(),
          'dataFinal': meta.dataFinal.toIso8601String(),
          'ativa': meta.ativa ? 1 : 0,
          'cor': meta.cor.toARGB32(),
        },
        where: 'id = ?',
        whereArgs: [meta.id],
      );

      // //Buscar ids das atividades antigas
      // final antigas = await txn.query(
      //   'atividades',
      //   where: 'metaId = ?',
      //   whereArgs: [meta.id],
      // );

      // final antigasIds = antigas.map((a) => a['id'] as String).toList();

      //Deletar dias das atividades antigas
      await txn.delete(
        'atividade_dias',
        where: 'atividadeId IN (SELECT id FROM atividades WHERE metaId = ?)',
        whereArgs: [meta.id],
      );

      //Deletar atividades antigas
      await txn.delete(
        'atividades',
        where: 'metaId = ?',
        whereArgs: [meta.id],
      );

      //Recriar atividades + dias
      for (final atividade in meta.atividades) {

        await txn.insert('atividades', {
          'id': atividade.id,
          'metaId': atividade.metaId,
          'nome': atividade.nome,
          'ativa': atividade.ativa ? 1 : 0,
          'cor': atividade.cor.toARGB32(),
        });

        if (atividade.diasSemana != null && atividade.diasSemana!.isNotEmpty) {

          for (final dia in atividade.diasSemana!) {
            await txn.insert(
              'atividade_dias',
              {
                'atividadeId': atividade.id,
                'diaSemana': dia.id,
              },
            );
          }
        }
      }
    });
  }

  @override
  Future<List<MetaModel>> getMetasByPeriodo(DateTime inicio, DateTime fim) async {
    final db = await dbHelper.database;

    final inicioStr = DateTime(inicio.year, inicio.month, inicio.day).toIso8601String();
    final fimStr = DateTime(fim.year, fim.month, fim.day).toIso8601String();

    final metasMap = await db.query(
      'metas',
      where: '''
        date(dataInicial) <= date(?)
        AND
        date(dataFinal) >= date(?)
      ''',
      whereArgs: [fimStr, inicioStr],
    );

    List<MetaModel> metas = [];

    for(var metaMap in metasMap){
      final atividadesMap = await db.query(
        'atividades',
        where: 'metaId = ?',
        whereArgs: [metaMap['id']],
      );

      List<AtividadeModel> atividades = [];

      for(var atividadeMap in atividadesMap){
        final diasMap = await db.query(
          'atividade_dias',
          where: 'atividadeId = ?',
          whereArgs: [atividadeMap['id']],
        );

        final dias = diasMap
          .map((d) => d['diaSemana'] as int)
          .map((id) => DiasSemana.fromId(id))
          .toList();

          atividades.add(
            AtividadeModel(
              id: atividadeMap['id'] as String,
              metaId: atividadeMap['metaId'] as String,
              nome: atividadeMap['nome'] as String,
              ativa: (atividadeMap['ativa'] as int) == 1,
              cor: Color(atividadeMap['cor'] as int),
              diasSemana: dias.isEmpty ? null : dias,
            ),
          );
      }

      metas.add(
        MetaModel(
          id: metaMap['id'] as String,
          nome: metaMap['nome'] as String,
          descricao: metaMap['descricao'] as String,
          tipo: MetaType.fromName(metaMap['tipo'] as String),
          objetivoQuantidade: metaMap['objetivoQuantidade'] == null ? 0 : metaMap['objetivoQuantidade'] as int,
          atividades: atividades,
          dataInicial: DateTime.parse(metaMap['dataInicial'] as String),
          dataFinal: DateTime.parse(metaMap['dataFinal'] as String),
          ativa: (metaMap['ativa'] as int) == 1,
          cor: Color(metaMap['cor'] as int),
        ),
      );
    }
    return metas;
  }

  @override
  Future<int> getTotalMetaByPeriodo(String metaId, DateTime inicio, DateTime fim) async {
    final db = await dbHelper.database;

    final inicioStr = DateTime(inicio.year, inicio.month, inicio.day).toIso8601String();
    final fimStr = DateTime(fim.year, fim.month, fim.day).toIso8601String();

    //Buscar tipo da meta
    final metaMap = await db.query(
      'metas',
      where: 'id = ?',
      whereArgs: [metaId],
    );

    if(metaMap.isEmpty) return 0; //Meta não encontrada

    final tipo = metaMap.first['tipo'] as String;

    //META ACUMULATIVA - SOMA QUANTIDADES NO PERÍODO
    if(tipo == MetaType.acumulativa.nome){
      final result = await db.rawQuery('''
        SELECT SUM(quantidade) as total
        FROM registros
        WHERE metaId = ?
        AND date(data) BETWEEN date(?) AND date(?)
        ''',
        [metaId, inicioStr, fimStr]);

        final total = result.first['total'];
        return total == null ? 0 : total as int;
    }

    //META COMPOSTA - CONTA REGISTROS DE ATIVIDADES POR DIA DISTINTO
    if(tipo == MetaType.composta.nome){
      final result = await db.rawQuery('''
        SELECT COUNT(DISTINCT date(data)) as total
        FROM registros
        WHERE metaId = ?
        AND date(data) BETWEEN date(?) AND date(?)
        ''',
        [metaId, inicioStr, fimStr]);

        final total = result.first['total'];
        return total == null ? 0 : total as int;
    }

    //META SIMPLES - CONTA REGISTROS NO PERÍODO
    final result = await db.rawQuery('''
      SELECT COUNT(*) as total
      FROM registros
      WHERE metaId = ?
      AND date(data) BETWEEN date(?) AND date(?)
      ''',
      [metaId, inicioStr, fimStr]); 

      final total = result.first['total'];
      return total == null ? 0 : total as int;
  }

}