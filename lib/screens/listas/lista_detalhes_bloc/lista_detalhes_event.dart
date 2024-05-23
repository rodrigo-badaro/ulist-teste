import 'dart:async';

import 'package:ulist/models/item_model/item_model.dart';
import 'package:ulist/widgets/animated_button/animated_button_cubit.dart';

abstract class ListaDetalhesEvent {}

class FetchListaDetalhesEvent extends ListaDetalhesEvent {
  String ref;
  FetchListaDetalhesEvent({
    required this.ref,
  });
}

class SearchListaDetalhesEvent extends ListaDetalhesEvent {
  String search;

  SearchListaDetalhesEvent({
    required this.search,
  });
}

class CreateTarefaDetalhesEvent extends ListaDetalhesEvent {
  ItemModel registro;
  AnimatedButtonCubit button;
  Completer completer;

  CreateTarefaDetalhesEvent({
    required this.registro,
    required this.button,
    required this.completer,
  });
}

class UpdateTarefaDetalhesEvent extends ListaDetalhesEvent {
  ItemModel registro;
  AnimatedButtonCubit button;
  Completer completer;

  UpdateTarefaDetalhesEvent({
    required this.registro,
    required this.button,
    required this.completer,
  });
}

class FinishTarefaDetalhesEvent extends ListaDetalhesEvent {
  ItemModel registro;

  FinishTarefaDetalhesEvent({
    required this.registro,
  });
}

class RemoveTarefaDetalhesEvent extends ListaDetalhesEvent {
  ItemModel? registro;
  AnimatedButtonCubit button;
  Completer completer;

  RemoveTarefaDetalhesEvent({
    required this.registro,
    required this.button,
    required this.completer,
  });
}

class CompleteTarefaDetalhesEvent extends ListaDetalhesEvent {
  ItemModel registro;
  AnimatedButtonCubit button;
  Completer completer;

  CompleteTarefaDetalhesEvent({
    required this.registro,
    required this.button,
    required this.completer,
  });
}
