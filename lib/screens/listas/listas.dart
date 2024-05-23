// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:ulist/get_it.dart';
import 'package:ulist/router.dart';
import 'package:ulist/screens/listas/bloc/listas_bloc.dart';
import 'package:ulist/screens/listas/bloc/listas_event.dart';
import 'package:ulist/screens/listas/listas_detalhes.dart';
import 'package:ulist/screens/listas/listas_table.dart';

class Listas extends StatefulWidget {
  final PageController? pageControllerListas;
  final dynamic ref;

  const Listas({
    super.key,
    this.pageControllerListas,
    this.ref,
  });

  @override
  State<Listas> createState() => _ListasState();
}

class _ListasState extends State<Listas> {
  final ListasBloc listasBloc = getIt<ListasBloc>();

  String? currentPath;

  @override
  void initState() {
    super.initState();

    listasBloc.add(FetchListasEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var initialPage = 0;
      navigatorKey.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        initialPage = currentPath == '/listas' ? 0 : 1;
        return true;
      });

      if (widget.pageControllerListas != null && initialPage == 1) {
        widget.pageControllerListas!.animateToPage(
          initialPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutQuint,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageControllerListas,
      children: [
        const ListasTable(),
        ListaDetalhes(ref: widget.ref),
      ],
    );
  }
}
