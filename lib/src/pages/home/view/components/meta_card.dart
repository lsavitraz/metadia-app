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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meta.nome, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            // LinearProgressIndicator(
            //   value: progresso,
            //   minHeight: 6,
            //   borderRadius: BorderRadius.circular(8),
            //   backgroundColor: meta.cor.withValues(alpha: 0.15),
            //   color: meta.cor,
            // ),
            Obx(() {
              final totalFeito = controller.quantidadeFeitosDaMeta(meta.id);
              final progresso = (totalFeito / meta.objetivoQuantidade).clamp(0.0, 1.0);
              final percentual = (progresso * 100).round();
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _AnimatedProgressBar(value: progresso, color: meta.cor),
                const SizedBox(height: 4),
                Text(
                  '$totalFeito / ${meta.objetivoQuantidade} (${percentual.toString()}%)', 
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: percentual >= 100 ? Colors.green : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                ),
                ],
              );
            }),

            const SizedBox(height: 12),
            ...meta.atividades.map((atividade) => AtividadeItem(meta: meta, atividade: atividade)),
          ],
        ),
      ),
    );
  }
}

class _AnimatedProgressBar extends StatefulWidget {
  final double value;
  final Color color;
  const _AnimatedProgressBar({super.key, required this.value, required this.color});

  @override
  State<_AnimatedProgressBar> createState() => __AnimatedProgressBarState();
}

class __AnimatedProgressBarState extends State<_AnimatedProgressBar> {
  double _oldValue = 0.0;

  @override
  void didUpdateWidget(covariant _AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _oldValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _oldValue, end: widget.value),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return LinearProgressIndicator(value: value, minHeight: 6, borderRadius: BorderRadius.circular(8), backgroundColor: widget.color.withValues(alpha: 0.15), color: widget.color);
      },
    );
  }
}
