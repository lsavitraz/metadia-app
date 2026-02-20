import 'package:metadia/src/model/meta_model.dart';
import 'package:metadia/src/model/registro_diario_model.dart';

abstract class HomeRepository {
  //Retorna todas as metas ativas
  Future<List<MetaModel>> getMetasAtivas();

  //Retorna os registros de um dia específico
  Future<List<RegistroDiarioModel>> getRegistrosByDate(DateTime dia);

  //Marca uma atividade como feita em um dia
  Future<void> registrarAtividade({
    required DateTime data,
    required String metaId,
    required String atividadeId,
  });
  //Decrementa a quantidade de uma atividade acumulativa
  Future<void> decrementarAtividade({
    required DateTime data,
    required String metaId,
    required String atividadeId,
  });

  //Salva meta
  Future<void> salvarMeta(MetaModel meta);

  //Totaliza as metas
  Future<int> getTotalMeta(String metaId);

  //Inativar meta
  Future<void> inativarMeta(String metaId);

  //Buscar meta por ID
  Future<MetaModel> getMetaById(String metaId);

  //Alterar Meta
  Future<void> updateMeta(MetaModel meta);
}