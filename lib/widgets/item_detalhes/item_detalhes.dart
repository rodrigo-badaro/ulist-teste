import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ulist/models/item_model/item_model.dart';
import 'package:ulist/widgets/animated_button/animated_button_cubit.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/typography/typography.dart';

class ItemDetalhes extends StatefulWidget {
  const ItemDetalhes({
    super.key,
    required this.initialValue,
  });

  final ItemModel? initialValue;

  @override
  State<ItemDetalhes> createState() => _ItemDetalhesState();
}

class _ItemDetalhesState extends State<ItemDetalhes> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final AnimatedButtonCubit button = AnimatedButtonCubit();
  final Completer completer = Completer();

  String createdAt = 'Não informado';
  String updatedAt = 'Não informado';
  String data = 'Não informado';
  String hora = 'Não informado';

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
        data = DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.initialValue!.data.millisecondsSinceEpoch));
      }

      createdAt = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.initialValue!.createdAt.millisecondsSinceEpoch));
      updatedAt = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.initialValue!.updatedAt.millisecondsSinceEpoch));
      hora = widget.initialValue?.horario ?? 'Não informado';
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
                        'DETALHES TAREFA',
                        color: PaletteColors.info,
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.only(right: 36),
                        child: Paragraph('Abaixo estão os dados da tarefa selecionada.'),
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
                    ListTile(
                      title: const TableHeader('Nome da tarefa'),
                      subtitle: Paragraph(widget.initialValue?.name ?? ''),
                    ),
                    Divider(
                      color: PaletteColors.info.withOpacity(0.3),
                      height: 0,
                    ),
                    ListTile(
                      title: const TableHeader('Descrição da tarefa'),
                      subtitle: Paragraph(widget.initialValue?.description ?? ''),
                    ),
                    Divider(
                      color: PaletteColors.info.withOpacity(0.3),
                      height: 0,
                    ),
                    ListTile(
                      title: const TableHeader('Status'),
                      subtitle: Paragraph(widget.initialValue?.completed ?? false ? 'FEITO!' : 'AGUARDANDO'),
                    ),
                    Divider(
                      color: PaletteColors.info.withOpacity(0.3),
                      height: 0,
                    ),
                    ListTile(
                      title: const TableHeader('Agendado para:'),
                      subtitle: Paragraph(data),
                    ),
                    Divider(
                      color: PaletteColors.info.withOpacity(0.3),
                      height: 0,
                    ),
                    ListTile(
                      title: const TableHeader('Horário agendado:'),
                      subtitle: Paragraph(hora),
                    ),
                    Divider(
                      color: PaletteColors.info.withOpacity(0.3),
                      height: 0,
                    ),
                    ListTile(
                      title: const TableHeader('Cadastrada em:'),
                      subtitle: Paragraph(createdAt),
                    ),
                    Divider(
                      color: PaletteColors.info.withOpacity(0.3),
                      height: 0,
                    ),
                    ListTile(
                      title: const TableHeader('Ultima alteração em:'),
                      subtitle: Paragraph(updatedAt),
                    ),
                    Divider(
                      color: PaletteColors.info.withOpacity(0.3),
                      height: 0,
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
