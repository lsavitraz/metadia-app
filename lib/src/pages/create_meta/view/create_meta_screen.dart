import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/constants/meta_type_enum.dart';
import 'package:metadia/src/pages/common_widgets/color_selector.dart';
import 'package:metadia/src/pages/common_widgets/period_selector.dart';
import 'package:metadia/src/pages/common_widgets/week_days_selector.dart';
import 'package:metadia/src/pages/create_meta/controller/create_meta_controller.dart';

class CreateMetaScreen extends GetView<CreateMetaController> {
  const CreateMetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Meta')),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GeneralSection(),
                const SizedBox(height: 24),
                _TypeSection(),
                
                const SizedBox(height: 24),
                _ColorSection(),
                
                const SizedBox(height: 24),
                _ObjectiveSection(),
                const SizedBox(height: 24),
                _PeriodSelector(),
                const SizedBox(height: 24),
                _DaysSection(),

                Obx(() {
                  if (!controller.isComposta) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Atividades',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(controller.atividades.length, (index) => _ActivityFormItem(index: index)),
                      const SizedBox(height: 12),
                      const _AddActivityButton(),
                    ],
                  );
                }),

                const SizedBox(height: 32),
                const _ElevatedSaveButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GeneralSection extends GetView<CreateMetaController> {
  const _GeneralSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informações', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.nomeController,
          decoration: const InputDecoration(labelText: 'Nome da Meta'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o nome da meta';
            }
            if (value.trim().length < 3) {
              return 'Mínimo de 3 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.descricaoController,
          decoration: const InputDecoration(labelText: 'Descrição (opcional)'),
          maxLines: 2,
        ),
      ],
    );
  }
}

class _TypeSection extends GetView<CreateMetaController> {
  const _TypeSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tipo de Meta', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),

          IntrinsicWidth(
            child: SegmentedButton<MetaType>(
              showSelectedIcon: false,
              style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 10))),
              segments: MetaType.values.map((tipo) {
                return ButtonSegment<MetaType>(value: tipo, label: Text(tipo.nome));
              }).toList(),
              selected: {controller.tipoSelecionado.value},
              onSelectionChanged: (value) {
                controller.alterarTipo(value.first);
              },
            ),
          ),
        ],
      );
    });
  }
}

class _ColorSection extends GetView<CreateMetaController> {
  const _ColorSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cor', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ColorSelector(
            selected: controller.corSelecionada.value,
            onSelect: controller.selecionarCor,
          ),
        ],
      );
    });
  }
}

class _ObjectiveSection extends GetView<CreateMetaController> {
  const _ObjectiveSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Objetivo', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.objetivoController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Quantidade à ser alcançada'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe a quantidade à ser alcançada';
            }
            final number = int.tryParse(value);
            if (number == null || number <= 0) {
              return 'Informe um número válido maior que zero';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _PeriodSelector extends GetView<CreateMetaController> {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PeriodSelector(
        dataInicial: controller.dataInicial.value,
        dataFinal: controller.dataFinal.value,
        onDataInicialChanged: (novaData) {
          controller.dataInicial.value = novaData;

          if (controller.dataFinal.value.isBefore(novaData)) {
            controller.dataFinal.value = novaData;
          }
        },
        onDataFinalChanged: (novadata) {
          controller.dataFinal.value = novadata;
        },
      );
    });
  }
}

class _DaysSection extends GetView<CreateMetaController> {
  const _DaysSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isComposta) {
        return const SizedBox.shrink();
      }
      final atividade = controller.atividades.first;

      return WeekDaysSelector(
        selected: atividade.diasSemana ?? [],
        onToggle: (dia) {
          controller.toggleDiaDaAtividade(0, dia);
        },
      );
    });
  }
}

class _ActivityFormItem extends GetView<CreateMetaController> {
  final int index;

  const _ActivityFormItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final atividade = controller.atividades[index];

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Padding(
          padding: EdgeInsetsGeometry.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: atividade.nome,
                decoration: const InputDecoration(labelText: 'Nome da atividade'),
                onChanged: (value) {
                  atividade.nome = value;
                  controller.atividades[index] = atividade;
                },
              ),
              const SizedBox(height: 12),
              WeekDaysSelector(selected: atividade.diasSemana ?? [], onToggle: (dia) => controller.toggleDiaDaAtividade(index, dia)),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(onPressed: () => controller.removerAtividade(index), icon: const Icon(Icons.delete_outline)),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _AddActivityButton extends GetView<CreateMetaController> {
  const _AddActivityButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        controller.adicionarAtividade('');
      },
      icon: const Icon(Icons.add),
      label: const Text('Adicionar atividade'),
    );
  }
}

class _ElevatedSaveButton extends GetView<CreateMetaController> {
  const _ElevatedSaveButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.salvarMeta,
        child: const Text('Salvar Meta'),
      ),
    );
  }
}