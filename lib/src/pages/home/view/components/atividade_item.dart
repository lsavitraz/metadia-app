import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/config/color_scheme.dart';
import 'package:metadia/src/model/atividade_model.dart';
import 'package:metadia/src/pages/home/controller/home_controller.dart';

class AtividadeItem extends StatelessWidget {
  final String metaId;
  final AtividadeModel atividade;

  const AtividadeItem({super.key, required this.metaId, required this.atividade});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final feito = controller.atividadeFeitaNoDia(metaId: metaId, atividadeId: atividade.id);

      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(atividade.nome, style: Theme.of(context).textTheme.bodyMedium),
        trailing: IconButton(
          icon: Icon(feito ? Icons.check_circle : Icons.radio_button_unchecked, color: feito ? AppColors.success : AppColors.pending),
          onPressed: () {
            if (!feito) {
              controller.marcarAtividadeComoFeita(metaId: metaId, atividadeId: atividade.id);
            }
          },
        ),
      );
    });
  }
}
