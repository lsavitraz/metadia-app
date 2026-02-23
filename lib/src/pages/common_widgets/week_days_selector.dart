import 'package:flutter/material.dart';
import 'package:metadia/src/constants/dias_semana_enum.dart';

class WeekDaysSelector extends StatelessWidget {
  final List<DiasSemana> selected;
  final ValueChanged<DiasSemana> onToggle;

  const WeekDaysSelector({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  static const List<DiasSemana> _orderedDays = [
    DiasSemana.domingo,
    DiasSemana.segunda,
    DiasSemana.terca,
    DiasSemana.quarta,
    DiasSemana.quinta,
    DiasSemana.sexta,
    DiasSemana.sabado,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dias da Semana',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),

        Row(
          children: _orderedDays.map((dia) {
            final isSelected = selected.contains(dia);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _DayChip(
                  label: _shortName(dia),
                  selected: isSelected,
                  onTap: () => onToggle(dia),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _shortName(DiasSemana dia) {
    switch (dia) {
      case DiasSemana.domingo:
        return 'DOM';
      case DiasSemana.segunda:
        return 'SEG';
      case DiasSemana.terca:
        return 'TER';
      case DiasSemana.quarta:
        return 'QUA';
      case DiasSemana.quinta:
        return 'QUI';
      case DiasSemana.sexta:
        return 'SEX';
      case DiasSemana.sabado:
        return 'SÁB';
    }
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? primary : Colors.transparent,
          border: Border.all(
            color: selected
                ? primary
                : primary.withValues(alpha: 0.35),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : primary,
              ),
        ),
      ),
    );
  }
}