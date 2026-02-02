import 'package:get/get.dart';
import 'package:metadia/src/constants/dias_semana_enum.dart';
import 'package:metadia/src/model/meta_model.dart';
import 'package:metadia/src/model/registro_diario_model.dart';
import 'package:metadia/src/pages/home/repository/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository repository;

  HomeController(this.repository);

  //Dia selecionado no calendário
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  //Metas ativas
  final RxList<MetaModel> metas = <MetaModel>[].obs;

  //Registros do dia selecionado
  final RxList<RegistroDiarioModel> registrosDoDia = <RegistroDiarioModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    carregarDados();
  }

  //Carrega metas e registros do dia
  Future<void> carregarDados() async {
    isLoading.value = true;

    try {
      metas.assignAll(await repository.getMetasAtivas());
      await _carregarRegistrosDoDia();
    } finally {
      isLoading.value = false;
    }
  }

  //Atualiza o dia selecionado
  Future<void> selecionarDia(DateTime data) async {
    selectedDate.value = data;
    await _carregarRegistrosDoDia();
  }

  //Carrega apenas registros do dia atual
  Future<void> _carregarRegistrosDoDia() async {
    registrosDoDia.assignAll(await repository.getRegistrosByDate(selectedDate.value));
  }

  //Marca uma atividade com "Feito"
  Future<void> marcarAtividadeComoFeita({required String metaId, required String atividadeId}) async {
    await repository.registrarAtividade(data: selectedDate.value, metaId: metaId, atividadeId: atividadeId);

    await _carregarRegistrosDoDia();
  }

  //Verifica se uma atividade já foi feita no dia selecionado
  bool atividadeFeitaNoDia({required String metaId, required String atividadeId}) {
    return registrosDoDia.any((registro) => registro.metaId == metaId && registro.atividadeId == atividadeId);
  }

  //Retorna a quantidade de atividades feitas da meta no dia
  int quantidadeFeitosDaMeta(String metaId) {
    return registrosDoDia.where((registro) => registro.metaId == metaId).length;
  }

  //Vai para a semana anterior
  Future<void> semanaAnterior() async {
    final novaData = selectedDate.value.subtract(const Duration(days: 7));
    await selecionarDia(novaData);
  }

  //Vai para a semana seguinte
  Future<void> proximaSemana() async {
    final novaData = selectedDate.value.add(const Duration(days: 7));
    await selecionarDia(novaData);
  }

  //Ir para o dia de hoje
  Future<void> irParaHoje() async {
    await selecionarDia(DateTime.now());
  }

  List<MetaModel> get metasDoDia {
    final diaAtual = DiasSemana.fromId(selectedDate.value.weekday);

    return metas.where((meta) {
      //Meta precisa estar ativa
      if (!meta.ativa) {
        return false;
      }

      //Dia precisa estar dentro do período da meta
      final dentroDoPeriodo = !selectedDate.value.isBefore(meta.dataInicial) && !selectedDate.value.isAfter(meta.dataFinal);
      if (!dentroDoPeriodo) {
        return false;
      }

      //Meta simples: sempre aparece
      if (meta.atividades.length == 1 && (meta.atividades.first.diasSemana == null || meta.atividades.first.diasSemana!.isEmpty)) {
        return true;
      }

      //Meta composta: precisa ter ao menos uma atividade válida
      return meta.atividades.any((atividade) {
        if(atividade.diasSemana == null || atividade.diasSemana!.isEmpty) {
          return true;
        }
        
        return atividade.diasSemana!.contains(diaAtual);
      });
    }).toList();
  }
}
