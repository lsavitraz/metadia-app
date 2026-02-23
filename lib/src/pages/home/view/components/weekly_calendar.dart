import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/config/color_scheme.dart';
import 'package:metadia/src/constants/dias_semana_enum.dart';
import 'package:metadia/src/pages/home/controller/home_controller.dart';

class WeeklyCalendar extends GetView<HomeController> {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDate = controller.selectedDate.value;
      final weekDays = _getWeekDays(selectedDate);

      return Row(
        children: [
          _ArrowButton(
            icon: Icons.arrow_back_ios,
            onTap: controller.semanaAnterior,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((date) {
                final isSelected = _isSameDay(date, selectedDate);

                return _DayItem(
                  date: date,
                  isSelected: isSelected,
                  onTap: () {
                    controller.selecionarDia(date);
                  },
                );
              }).toList(),
            ),
          ),
          _ArrowButton(
            icon: Icons.arrow_forward_ios,
            onTap: controller.proximaSemana,
          ),
        ],
      );
    });
  }

  List<DateTime> _getWeekDays(DateTime reference) {
    final startOfWeek = reference.subtract(Duration(days: reference.weekday % 7));

    return List.generate(7, (index) => DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + index));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DayItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayItem({required this.date, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dayEnum = DiasSemana.fromId(date.weekday);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              dayEnum.nome.substring(0, 3).toUpperCase(),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  
  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Icon(
        icon,
        color: AppColors.primary,
      ),
    );
  }
}