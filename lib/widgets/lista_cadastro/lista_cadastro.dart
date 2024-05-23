import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ulist/models/lista_model/lista_model.dart';
import 'package:ulist/widgets/animated_button/animated_button.dart';
import 'package:ulist/widgets/animated_button/animated_button_cubit.dart';
import 'package:ulist/widgets/custom_input/custom_input.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/typography/typography.dart';

class ListaCadastro extends StatefulWidget {
  const ListaCadastro({super.key, required this.onComplete, this.initialValue});

  final ListaModel? initialValue;
  final Function(
    ListaModel lista,
    Completer completer,
    AnimatedButtonCubit button,
  ) onComplete;

  @override
  State<ListaCadastro> createState() => _ListaCadastroState();
}

class _ListaCadastroState extends State<ListaCadastro> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AnimatedButtonCubit button = AnimatedButtonCubit();
  final Completer completer = Completer();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([completer.future]).then((value) => Navigator.pop(context, completer.isCompleted));
    });

    if (widget.initialValue != null) {
      _nameController.text = widget.initialValue?.name ?? '';
      _descriptionController.text = widget.initialValue?.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                        'ADICIONAR LISTA',
                        color: PaletteColors.info,
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.only(right: 36),
                        child: Paragraph('Informe os dados abaixo para cadastrar uma nova lista.'),
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
                                controller: _nameController,
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
                                      ListaModel lista = ListaModel(
                                        name: _nameController.text,
                                        description: _descriptionController.text,
                                        createdAt: Timestamp.now(),
                                        updatedAt: Timestamp.now(),
                                        items: [],
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
