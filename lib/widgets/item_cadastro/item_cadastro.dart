import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ulist/models/item_model/item_model.dart';
import 'package:ulist/widgets/animated_button/animated_button.dart';
import 'package:ulist/widgets/animated_button/animated_button_cubit.dart';
import 'package:ulist/widgets/custom_input/custom_input.dart';
import 'package:ulist/widgets/date_picker/date_picker.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/time_picker/time_picker.dart';
import 'package:ulist/widgets/typography/typography.dart';

class ItemCadastro extends StatefulWidget {
  const ItemCadastro({
    super.key,
    this.initialValue,
    required this.onComplete,
  });

  final ItemModel? initialValue;
  final Function(
    ItemModel data,
    Completer completer,
    AnimatedButtonCubit button,
  ) onComplete;

  @override
  State<ItemCadastro> createState() => _ItemCadastroState();
}

class _ItemCadastroState extends State<ItemCadastro> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AnimatedButtonCubit button = AnimatedButtonCubit();
  final Completer completer = Completer();

  final GlobalKey _dataKey = GlobalKey();
  final GlobalKey _horarioKey = GlobalKey();

  final ValueNotifier<DateTime> data = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay?> horario = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([completer.future]).then((value) => Navigator.pop(context, completer.isCompleted));
    });

    if (widget.initialValue != null) {
      _nomeController.text = widget.initialValue?.name ?? '';
      _descriptionController.text = widget.initialValue?.description ?? '';

      if (widget.initialValue?.data != null) {
        data.value = DateTime.fromMillisecondsSinceEpoch(widget.initialValue!.data.millisecondsSinceEpoch);
      }

      if (widget.initialValue?.horario != null) {
        String hora = widget.initialValue!.horario!;

        horario.value = TimeOfDay(hour: int.parse(hora.split(':')[0]), minute: int.parse(hora.split(':')[1]));
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      isThreeLine: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: const H1Small(
                        'ADICIONAR TAREFA',
                        color: PaletteColors.info,
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.only(right: 36),
                        child: Paragraph('Informe os dados abaixo para cadastrar uma nova tarefa.'),
                      ),
                      trailing: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.clear,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Wrap(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: CustomInput(
                                label: 'Nome',
                                controller: _nomeController,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: CustomInput(
                                label: 'Descrição',
                                controller: _descriptionController,
                                keyboardType: TextInputType.number,
                                minLines: 5,
                                maxLines: null,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ListenableBuilder(
                                  listenable: data,
                                  builder: (context, snapshot) {
                                    return CustomInput(
                                      label: 'Data',
                                      readOnly: true,
                                      initialValue: DateFormat('dd/MM/yyyy').format(data.value),
                                      actions: [
                                        InkWell(
                                          onTap: () {
                                            final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                                            final RenderBox containerBox = _dataKey.currentContext?.findRenderObject() as RenderBox;
                                            final Offset containerPosition = containerBox.localToGlobal(Offset.zero);

                                            showMenu(
                                              color: Colors.white,
                                              surfaceTintColor: PaletteColors.white,
                                              elevation: 16,
                                              context: context,
                                              constraints: const BoxConstraints(
                                                minWidth: 430,
                                                maxWidth: 430,
                                              ),
                                              position: RelativeRect.fromRect(
                                                Offset(containerPosition.dx, containerPosition.dy + 34) & containerBox.size, // Posição e tamanho do Container
                                                Offset.zero & overlay.size, // Tamanho da tela completa
                                              ),
                                              items: [
                                                PopupMenuItem(
                                                  enabled: false,
                                                  mouseCursor: MouseCursor.defer,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: const TableHeader('Selecione a data'),
                                                          trailing: TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 18,
                                                              color: PaletteColors.info,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 12),
                                                          child: SizedBox(
                                                            height: 230,
                                                            child: DatePicker(
                                                              initialValue: data.value,
                                                              onChange: (newDate) {
                                                                data.value = newDate;
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Expanded(
                                                                flex: 3,
                                                                child: ElevatedButton(
                                                                  style: const ButtonStyle(
                                                                    backgroundColor: MaterialStatePropertyAll(
                                                                      PaletteColors.primary,
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: const Paragraph(
                                                                    'Selecionar',
                                                                    color: PaletteColors.white,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          child: SizedBox(
                                            key: _dataKey,
                                            height: double.infinity,
                                            width: 50,
                                            child: const Center(
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                                color: PaletteColors.info,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ListenableBuilder(
                                listenable: horario,
                                builder: (context, child) {
                                  return CustomInput(
                                    label: 'Horário',
                                    readOnly: true,
                                    initialValue: horario.value != null ? '${horario.value?.hour.toString().padLeft(2, '0')}:${horario.value?.minute.toString().padLeft(2, '0')}' : 'Não defindo',
                                    actions: [
                                      InkWell(
                                        onTap: () {
                                          final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                                          final RenderBox containerBox = _horarioKey.currentContext?.findRenderObject() as RenderBox;
                                          final Offset containerPosition = containerBox.localToGlobal(Offset.zero);

                                          showMenu(
                                            color: Colors.white,
                                            surfaceTintColor: PaletteColors.white,
                                            elevation: 16,
                                            context: context,
                                            constraints: const BoxConstraints(
                                              minWidth: 430,
                                              maxWidth: 430,
                                            ),
                                            position: RelativeRect.fromRect(
                                              Offset(containerPosition.dx, containerPosition.dy + 34) & containerBox.size, // Posição e tamanho do Container
                                              Offset.zero & overlay.size, // Tamanho da tela completa
                                            ),
                                            items: [
                                              PopupMenuItem(
                                                enabled: false,
                                                mouseCursor: MouseCursor.defer,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ListTile(
                                                        contentPadding: EdgeInsets.zero,
                                                        title: const TableHeader('HORÁRIO'),
                                                        trailing: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 18,
                                                            color: PaletteColors.info,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 12),
                                                        child: SizedBox(
                                                          height: 140,
                                                          child: TimePicker(
                                                            initialValue: DateTime(2023, 10, 26, horario.value?.hour ?? 0, horario.value?.minute ?? 00),
                                                            onChange: (dateTime) {
                                                              horario.value = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: ElevatedButton(
                                                                style: const ButtonStyle(
                                                                  backgroundColor: MaterialStatePropertyAll(
                                                                    PaletteColors.danger,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  horario.value = null;
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Paragraph(
                                                                  'Remover',
                                                                  color: PaletteColors.white,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: ElevatedButton(
                                                                style: const ButtonStyle(
                                                                  backgroundColor: MaterialStatePropertyAll(
                                                                    PaletteColors.primary,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  horario.value ??= const TimeOfDay(hour: 00, minute: 00);
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Paragraph(
                                                                  'Selecionar',
                                                                  color: PaletteColors.white,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        child: SizedBox(
                                          key: _horarioKey,
                                          height: double.infinity,
                                          width: 50,
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              color: PaletteColors.info,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: SelectionContainer.disabled(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Divider(height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
                                    child: const Paragraph(
                                      'Fechar',
                                      color: PaletteColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AnimatedButton(
                                    formKey: _formKey,
                                    function: () {
                                      ItemModel lista = ItemModel(
                                        name: _nomeController.text,
                                        description: _descriptionController.text,
                                        data: Timestamp.fromDate(data.value),
                                        horario: horario.value != null ? '${horario.value?.hour.toString().padLeft(2, '0')}:${horario.value?.minute.toString().padLeft(2, '0')}' : null,
                                        createdAt: Timestamp.now(),
                                        updatedAt: Timestamp.now(),
                                        completed: false,
                                      );

                                      widget.onComplete.call(
                                        lista,
                                        completer,
                                        button,
                                      );
                                    },
                                    cubit: button,
                                    width: 600,
                                    color: PaletteColors.primary,
                                    title: 'Cadastrar',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
