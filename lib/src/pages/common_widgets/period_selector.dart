import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  final DateTime dataInicial;
  final DateTime dataFinal;
  final ValueChanged<DateTime> onDataInicialChanged;
  final ValueChanged<DateTime> onDataFinalChanged;

  const PeriodSelector({
    super.key,
    required this.dataInicial,
    required this.dataFinal,
    required this.onDataInicialChanged,
    required this.onDataFinalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Período',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DateField(
                label: 'Data Inicial', 
                date: dataInicial, 
                onTap: () async {
                  final picked = await _pickDate(
                    context,
                    initialDate: dataInicial,
                    firstDate: DateTime(2020),
                  );
                  if(picked != null){
                    onDataInicialChanged(picked);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateField(
                label: 'Data Final', 
                date: dataFinal, 
                onTap: () async {
                  final picked = await _pickDate(
                    context,
                    initialDate: dataFinal,
                    firstDate: dataInicial,
                  );
                  if(picked != null){
                    onDataFinalChanged(picked);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<DateTime?> _pickDate(
    BuildContext context,
    {
      required DateTime initialDate,
      required DateTime firstDate,
    }) {
      return showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: DateTime(2100),
        );
    }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.08),
              primary.withValues(alpha: 0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: primary.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10, 
          vertical: 12,   
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6), 
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month,
                size: 16, 
                color: primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: primary.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        //'${date.year.toString().substring(2)}'; // 26 ao invés de 2026
        '${date.year}';
  }
}