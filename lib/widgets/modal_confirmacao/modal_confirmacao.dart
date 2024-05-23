import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ulist/widgets/animated_button/animated_button.dart';
import 'package:ulist/widgets/animated_button/animated_button_cubit.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/typography/typography.dart';

class ModalConfirmacao extends StatefulWidget {
  const ModalConfirmacao({
    super.key,
    required this.title,
    required this.substitle,
    required this.onComplete,
  });

  final String title;
  final String? substitle;
  final Function(
    bool value,
    Completer completer,
    AnimatedButtonCubit button,
  ) onComplete;

  @override
  State<ModalConfirmacao> createState() => _ModalConfirmacaoState();
}

class _ModalConfirmacaoState extends State<ModalConfirmacao> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AnimatedButtonCubit button = AnimatedButtonCubit();
  final Completer completer = Completer();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([completer.future]).then((value) => Navigator.pop(context, completer.isCompleted));
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();

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
            Form(
            key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.dangerous,
                        color: PaletteColors.danger,
                        size: 32,
                      ),
                      H1Small(
                        widget.title,
                        color: PaletteColors.danger,
                        textAlign: TextAlign.center,
                      ),
                      Paragraph(
                        widget.substitle ?? '',
                        color: PaletteColors.danger,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 64),
                        child: SelectionContainer.disabled(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
                                  child: const Paragraph(
                                    'Fechar',
                                    color: PaletteColors.danger,
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
                                    widget.onComplete.call(true, completer, button);
                                  },
                                  cubit: button,
                                  width: 600,
                                  color: PaletteColors.danger,
                                  title: 'Remover',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
