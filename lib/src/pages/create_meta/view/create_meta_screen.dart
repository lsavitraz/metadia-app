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
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Editar Meta' : 'Nova Meta'),
      ),
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

                if (controller.isEditing) ...[
                  const SizedBox(height: 24),
                  const _DangerZoneSection(),
                ],


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
          focusNode: controller.nomeFocusNode,
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

class _HelpSection extends StatelessWidget {
  final String title;
  final String description;
  final List<String> rules;
  final List<String> examples;

  const _HelpSection({
    required this.title,
    required this.description,
    required this.rules,
    required this.examples,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Como funciona',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        ...rules.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '• $item',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Exemplos',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        ...examples.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '• $item',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}

class _TypeSection extends GetView<CreateMetaController> {
  const _TypeSection();

  void _showMetaTypesHelp(BuildContext context) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipos de Meta',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  _HelpSection(
                    title: 'Meta Simples',
                    description:
                        'Modelo voltado para hábitos que precisam ser realizados individualmente.',
                    rules: [
                      'Possui exatamente uma atividade.',
                      'Permite apenas marcar como feito ou não feito.',
                      'Ao marcar, cria um registro.',
                      'Ao desmarcar, remove o registro.',
                      'O progresso é calculado pela quantidade de registros.',
                    ],
                    examples: [
                      'Meditar',
                      'Ler',
                      'Caminhar',
                      'Estudar',
                    ],
                  ),

                  const SizedBox(height: 20),

                  _HelpSection(
                    title: 'Meta Composta',
                    description:
                        'Modelo voltado para metas formadas por múltiplas atividades.',
                    rules: [
                      'Possui uma ou mais atividades.',
                      'Cada atividade pode ter dias específicos da semana.',
                      'Cada atividade funciona como checklist.',
                      'O progresso considera os dias distintos em que houve execução.',
                      'Mais de uma atividade no mesmo dia conta como um único dia de progresso.',
                    ],
                    examples: [
                      'Projeto Saúde: caminhada, academia e alongamento.',
                      'Estudos: leitura, exercícios e aulas.',
                    ],
                  ),

                  const SizedBox(height: 20),

                  _HelpSection(
                    title: 'Meta Acumulativa',
                    description:
                        'Modelo voltado para metas que acumulam quantidade ao longo do tempo.',
                    rules: [
                      'Permite múltiplos incrementos no mesmo dia.',
                      'O botão + aumenta a quantidade.',
                      'O botão - diminui a quantidade.',
                      'Quando a quantidade chega a zero, o registro é removido.',
                      'O progresso é calculado pela soma das quantidades.',
                    ],
                    examples: [
                      'Copos de água',
                      'Páginas lidas',
                      'Minutos estudados',
                      'Quilômetros percorridos',
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: Get.back,
                      child: const Text('Entendi'),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Tipo de Meta',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Ajuda sobre tipos de meta',
                icon: const Icon(Icons.help_outline, size: 20),
                onPressed: () {
                  _showMetaTypesHelp(context);
                },
              ),
            ],
          ),
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

      if(controller.atividades.isEmpty){
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

class _DangerZoneSection extends GetView<CreateMetaController> {
  const _DangerZoneSection();

  Future<void> _showDuplicarMetaDialog(BuildContext context) async {
    final nomeNovaMetaController = TextEditingController(
      text: '${controller.nomeController.text.trim()} (cópia)',
    );

    final dataInicialNova = controller.dataInicial.value.obs;
    final dataFinalNova = controller.dataFinal.value.obs;

    await Get.dialog(
      AlertDialog(
        title: const Text('Duplicar meta'),
        content: Obx(() {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeNovaMetaController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da nova meta',
                  ),
                ),
                const SizedBox(height: 16),
                PeriodSelector(
                  dataInicial: dataInicialNova.value,
                  dataFinal: dataFinalNova.value,
                  onDataInicialChanged: (novaData) {
                    dataInicialNova.value = novaData;

                    if (dataFinalNova.value.isBefore(novaData)) {
                      dataFinalNova.value = novaData;
                    }
                  },
                  onDataFinalChanged: (novaData) {
                    dataFinalNova.value = novaData;
                  },
                ),
              ],
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
            final novoNome = nomeNovaMetaController.text;
            final novaDataInicial = dataInicialNova.value;
            final novaDataFinal = dataFinalNova.value;

            Get.back();

            final novaMetaId = await controller.duplicarMeta(
              novoNome: novoNome,
              novaDataInicial: novaDataInicial,
              novaDataFinal: novaDataFinal,
            );

            if (novaMetaId != null) {
              await controller.carregarMetaDuplicadaParaEdicao(novaMetaId);
            }
          },
            child: const Text('Duplicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ações da meta', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Estas ações afetam apenas esta meta.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showDuplicarMetaDialog(context);
                },
                icon: const Icon(Icons.copy_outlined),
                label: const Text('Duplicar meta'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirmar = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('Limpar dados da meta'),
                      content: const Text(
                        'Deseja zerar todo o progresso desta meta?\n\n'
                        'A configuração, o período e as atividades serão mantidos.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Limpar dados'),
                        ),
                      ],
                    ),
                  );

                  if (confirmar == true) {
                    await controller.limparProgressoMeta();
                  }
                },
                icon: const Icon(Icons.cleaning_services_outlined),
                label: const Text('Limpar dados da meta'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: () async {
                  final confirmar = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('Excluir meta'),
                      content: const Text(
                        'Deseja excluir definitivamente esta meta?\n\n'
                        'Esta ação removerá a meta, atividades e todo o histórico relacionado. '
                        'Não será possível desfazer.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Get.back(result: true),
                          child: const Text('Excluir definitivamente'),
                        ),
                      ],
                    ),
                  );

                  if (confirmar == true) {
                    await controller.excluirMeta();
                  }
                },
                icon: const Icon(Icons.delete_forever_outlined),
                label: const Text('Excluir meta definitivamente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}