import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/config/color_scheme.dart';
import 'package:metadia/src/constants/meta_type_enum.dart';
import 'package:metadia/src/model/atividade_model.dart';
import 'package:metadia/src/model/meta_model.dart';
import 'package:metadia/src/pages/home/controller/home_controller.dart';

class AtividadeItem extends StatelessWidget {
  final MetaModel meta;
  final AtividadeModel atividade;

  const AtividadeItem({super.key, required this.meta, required this.atividade});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (meta.tipo == MetaType.acumulativa) {
        final quantidade = controller.quantidadeFeitosDaAtividade(metaId: meta.id, atividadeId: atividade.id);

        return _CounterControl(
          quantidade: quantidade,
          onIncrement: () => controller.marcarAtividade(metaId: meta.id, atividadeId: atividade.id),
          onDecrement: () => controller.decrementarAtividade(metaId: meta.id, atividadeId: atividade.id),
        );
      }

      final feito = controller.atividadeFeitaNoDia(metaId: meta.id, atividadeId: atividade.id);

      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(atividade.nome, style: Theme.of(context).textTheme.bodyMedium),
        trailing: IconButton(
          icon: Icon(feito ? Icons.check_circle : Icons.radio_button_unchecked, color: feito ? AppColors.success : AppColors.pending),
          onPressed: () {
            controller.marcarAtividade(metaId: meta.id, atividadeId: atividade.id);
        },
        ),
      );
    });
  }
}

class _CounterControl extends StatelessWidget {
  final int quantidade;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CounterControl({super.key, required this.quantidade, required this.onIncrement, required this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CounterButton(icon: Icons.remove, onTap: quantidade > 0 ? onDecrement : null),
        const SizedBox(width: 12),
        Text(quantidade.toString(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        _CounterButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CounterButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
