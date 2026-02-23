import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/pages/common_widgets/period_selector.dart';
import 'package:metadia/src/pages/reports/controller/reports_controller.dart';

class ReportsTab extends GetView<ReportsController>{
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if(controller.isLoading.value){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PeriodoSection(),
                const SizedBox(height: 24.0),
                Expanded(
                  child: controller.resultados.isEmpty
                    ? const Center(
                        child: Text('Nenhuma meta encontrada no período.'),
                      )
                    : ListView.builder(
                        itemCount: controller.resultados.length,
                        itemBuilder: (context, index) {
                          final item = controller.resultados[index];
                          return _MetaResultadoCard(item: item);
                        },
                      ),
                ),
                
              ],
            );
          }),
        )
      ),
    );
  }
}


class _PeriodoSection extends GetView<ReportsController>{
  const _PeriodoSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PeriodSelector(
        dataInicial: controller.dataInicial.value, 
        dataFinal: controller.dataFinal.value, 
        onDataInicialChanged: (novaData) {          
          controller.alterarPeriodo(novaData, controller.dataFinal.value);
        }, 
        onDataFinalChanged: (novaData) {
          controller.alterarPeriodo(controller.dataInicial.value, novaData);
        }
      );
    });
  }
}

class _MetaResultadoCard extends StatelessWidget {
  final dynamic item;

  const _MetaResultadoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final percentualPeriodo = item.percentualPeriodo.toStringAsFixed(0);
    final percentualGeral = item.percentualGeral.toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.nome,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              '${item.totalNoPeriodo} / ${item.objetivo}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: item.percentualPeriodo / 100,
              minHeight: 6,
              semanticsLabel: 'Progresso no período',
            ),
            const SizedBox(height: 6.0),
            Text(
              '$percentualPeriodo% no período',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6.0),
            Text(
              'Progresso geral: $percentualGeral%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )
    );
  }
}