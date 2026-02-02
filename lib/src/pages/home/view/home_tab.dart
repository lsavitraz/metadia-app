import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/constants/meses_enum.dart';
import 'package:metadia/src/pages/home/controller/home_controller.dart';
import 'package:metadia/src/pages/home/view/components/meta_card.dart';
import 'package:metadia/src/pages/home/view/components/weekly_calendar.dart';

class HomeTab extends GetView<HomeController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView(
        padding: const EdgeInsets.all(8), 
        children: [
          _buildHeader(context),
          const WeeklyCalendar(),
          const SizedBox(height: 16),

          if(controller.metasDoDia.isEmpty)
            const _EmptyState()
          else
            ...controller.metasDoDia.map((meta) => MetaCard(meta: meta)),
        ],
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    final date = controller.selectedDate.value;
    final mesEnum = Meses.fromId(date.month);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${mesEnum.nome} ${date.year}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        TextButton(
          onPressed: controller.irParaHoje,
          child: Text('Hoje'),
        )
      ],
    );
  }
}


class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.free_breakfast_outlined,
            size: 48,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Dia livre 🎉',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Nenhuma meta para hoje.\nAproveite para descansar ou planejar algo novo.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
    );
  }
}