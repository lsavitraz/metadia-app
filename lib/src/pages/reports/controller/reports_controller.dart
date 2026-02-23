import 'package:get/get.dart';
import 'package:metadia/src/model/report_meta_result.dart';
import 'package:metadia/src/pages/home/repository/home_repository.dart';

class ReportsController extends GetxController {
  final HomeRepository homeRepository;

  ReportsController({required this.homeRepository});

  final Rx<DateTime> dataInicial = DateTime.now().subtract(const Duration(days: 30)).obs;
  final Rx<DateTime> dataFinal = DateTime.now().obs;

  final RxList<ReportMetaResult> resultados = <ReportMetaResult>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    carregarRelatorio();
  }

  Future<void> carregarRelatorio() async {
    isLoading.value = true;

    try {
      resultados.clear();

      final metas = await homeRepository.getMetasByPeriodo(
        dataInicial.value,
        dataFinal.value,
      );

      final listaResultados = await Future.wait(
        metas.map((meta) async {
          final totalPeriodo =
              await homeRepository.getTotalMetaByPeriodo(
            meta.id,
            dataInicial.value,
            dataFinal.value,
          );

          final totalGeral =
              await homeRepository.getTotalMeta(meta.id);

          final percentualPeriodo =
              meta.objetivoQuantidade == 0
                  ? 0.0
                  : (totalPeriodo / meta.objetivoQuantidade) * 100;

          final percentualGeral =
              meta.objetivoQuantidade == 0
                  ? 0.0
                  : (totalGeral / meta.objetivoQuantidade) * 100;

          return ReportMetaResult(
            metaId: meta.id,
            nome: meta.nome,
            objetivo: meta.objetivoQuantidade,
            totalNoPeriodo: totalPeriodo,
            totalGeral: totalGeral,
            percentualPeriodo:
                percentualPeriodo.clamp(0.0, 100.0),
            percentualGeral:
                percentualGeral.clamp(0.0, 100.0),
            dataInicial: meta.dataInicial,
            dataFinal: meta.dataFinal,
          );
        }),
      );

      resultados.assignAll(listaResultados);

      resultados.sort(
        (a, b) =>
            b.percentualPeriodo.compareTo(a.percentualPeriodo),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void alterarPeriodo(DateTime inicio, DateTime fim) {
    if (fim.isBefore(inicio)) {
      fim = inicio;
    }

    dataInicial.value = inicio;
    dataFinal.value = fim;

    carregarRelatorio();
  }

}