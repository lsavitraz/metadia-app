import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/constants/dias_semana_enum.dart';
import 'package:metadia/src/model/meta_model.dart';
import 'package:metadia/src/pages/home/controller/home_controller.dart';
import 'package:metadia/src/pages/home/view/components/atividade_item.dart';

class MetaCard extends StatelessWidget {
  final MetaModel meta;
  const MetaCard({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final diaAtual = DiasSemana.fromId(controller.selectedDate.value.weekday);

    return Card(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meta.nome, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...meta.atividades.map((atividade) => AtividadeItem(metaId: meta.id, atividade: atividade)),
          ],
        ),
      ),
    );
  }
}
