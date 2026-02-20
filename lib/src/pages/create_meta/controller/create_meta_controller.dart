import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/config/color_scheme.dart';
import 'package:metadia/src/constants/dias_semana_enum.dart';
import 'package:metadia/src/constants/meta_type_enum.dart';
import 'package:metadia/src/model/atividade_model.dart';
import 'package:metadia/src/model/meta_model.dart';
import 'package:metadia/src/pages/home/controller/home_controller.dart';
import 'package:metadia/src/pages/home/repository/home_repository.dart';
import 'package:uuid/uuid.dart';

class CreateMetaController extends GetxController {
  final HomeRepository repository;

  CreateMetaController(this.repository);

  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final objetivoController = TextEditingController();

  final Rx<MetaType> tipoSelecionado = MetaType.simples.obs;

  final Rx<DateTime> dataInicial = DateTime.now().obs;
  final Rx<DateTime> dataFinal = DateTime.now().add(const Duration(days: 30)).obs;

  //  final RxList<DiasSemana> diasSelecionados = <DiasSemana>[].obs;

  final RxList<AtividadeModel> atividades = <AtividadeModel>[].obs;

  bool get isComposta => tipoSelecionado.value == MetaType.composta;
  bool get isaAcumulativa => tipoSelecionado.value == MetaType.acumulativa;

  final _uuid = const Uuid();

  final Rx<Color> corSelecionada = AppColors.primary.obs;

  String? metaId; // Se for edição, terá o ID da meta sendo editada
  bool get isEditing => metaId != null;

  @override
  void onInit() {
    super.onInit();

    metaId = Get.arguments as String?;

    if(metaId != null){
      _carregarMetaParaEdicao();
    } else {
      _criarAtividadePadrao();
    }
  }

  MetaModel _buildMetaModel(){
    final id = metaId ?? const Uuid().v4();

    final dataIni = DateTime(dataInicial.value.year, dataInicial.value.month, dataInicial.value.day);
    final dataFim = DateTime(dataFinal.value.year, dataFinal.value.month, dataFinal.value.day);

    final atividadesAtualizadas = atividades.map((atividade) {
      return AtividadeModel(
        id: atividade.id, 
        metaId: id,
        nome: atividade.nome, 
        ativa: atividade.ativa,
        cor: atividade.cor,
        diasSemana: atividade.diasSemana,
      );
    }).toList();

    return MetaModel(
      id: id,
      nome: nomeController.text.trim(),
      descricao: descricaoController.text.trim(),
      tipo: tipoSelecionado.value,
      objetivoQuantidade: int.parse(objetivoController.text.trim()),
      atividades: atividadesAtualizadas,
      dataInicial: dataIni,
      dataFinal: dataFim,
      ativa: true,
      arquivadaEm: null,
      cor: corSelecionada.value,
    );
  }

  void selecionarCor(Color cor) {
    corSelecionada.value = cor;
  }

  void _criarAtividadePadrao() {
    atividades.add(AtividadeModel(id: UniqueKey().toString(), metaId: '', nome: '', ativa: true, cor: corSelecionada.value));
  }

  Future<void> _carregarMetaParaEdicao() async {
    final meta = await repository.getMetaById(metaId!);

    nomeController.text = meta.nome;
    descricaoController.text = meta.descricao;
    objetivoController.text = meta.objetivoQuantidade.toString();
    tipoSelecionado.value = meta.tipo;
    dataInicial.value = meta.dataInicial;
    dataFinal.value = meta.dataFinal;
    corSelecionada.value = meta.cor;
    atividades.assignAll(meta.atividades);

  }

  void alterarTipo(MetaType tipo) {
    tipoSelecionado.value = tipo;

    if (isComposta) {
      // Se for composta e não tiver nenhuma atividade, cria uma
      if (atividades.isEmpty) {
        _criarAtividadePadrao();
      }
    } else {
      // Se não for composta, manter apenas 1 atividade
      if (atividades.isEmpty) {
        _criarAtividadePadrao();
      } else {
        atividades.assignAll([atividades.first]);
      }
    }
  }

  // void toggleDia(DiasSemana dia) {
  //   if (diasSelecionados.contains(dia)) {
  //     diasSelecionados.remove(dia);
  //   } else {
  //     diasSelecionados.add(dia);
  //   }
  // }

  void toggleDiaDaAtividade(int index, DiasSemana dia) {
    final atividade = atividades[index];

    atividade.diasSemana ??= [];

    if (atividade.diasSemana!.contains(dia)) {
      atividade.diasSemana!.remove(dia);
    } else {
      atividade.diasSemana!.add(dia);
    }

    atividades[index] = atividade; // Força atualização do RXList
  }

  void adicionarAtividade(String nome) {
    atividades.add(AtividadeModel(id: UniqueKey().toString(), metaId: '', nome: nome, ativa: true, cor: corSelecionada.value));
  }

  void removerAtividade(int index) {
    atividades.removeAt(index);
  }

  bool validarFormulario() {
    // Validação padrão dos TextFormField
    final form = formKey.currentState;

    if (form == null) return false;

    if (!form.validate()) return false;

    // Período
    if (dataFinal.value.isBefore(dataInicial.value)) {
      Get.snackbar('Período inválido', 'A data final não pode ser anterior à data inicial.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // Atividades
    if (atividades.isEmpty) {
      Get.snackbar('Atividades', 'Adicione pelo menos uma atividade.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (isComposta) {
      for (var atividade in atividades) {
        if (atividade.nome.trim().isEmpty) {
          Get.snackbar('Atividade inválida', 'Todas as atividades precisam ter nome.', snackPosition: SnackPosition.BOTTOM);
          return false;
        }
      }
    }

    return true;
  }

  void salvarMeta() async {
    if(!validarFormulario()) return;

    final meta = _buildMetaModel();

    if(isEditing){
      await repository.updateMeta(meta);
    } else{
      await repository.salvarMeta(meta);
    }

    Get.find<HomeController>().carregarDados();
    
    Get.back();
  }
}
