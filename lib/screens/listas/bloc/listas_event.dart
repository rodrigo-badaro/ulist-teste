import 'dart:async';

import 'package:ulist/models/lista_model/lista_model.dart';
import 'package:ulist/widgets/animated_button/animated_button_cubit.dart';

abstract class ListasEvent {}

class FetchListasEvent extends ListasEvent {
  FetchListasEvent();
}

class SearchListasEvent extends ListasEvent {
  String search;

  SearchListasEvent({
    required this.search,
  });
}

class CreateListasEvent extends ListasEvent {
  ListaModel registro;
  AnimatedButtonCubit button;
  Completer completer;

  CreateListasEvent({
    required this.registro,
    required this.button,
    required this.completer,
  });
}

class UpdateListasEvent extends ListasEvent {
  ListaModel registro;
  AnimatedButtonCubit button;
  Completer completer;

  UpdateListasEvent({
    required this.registro,
    required this.button,
    required this.completer,
  });
}

class RemoveListasEvent extends ListasEvent {
  ListaModel registro;
  AnimatedButtonCubit button;
  Completer completer;

  RemoveListasEvent({
    required this.registro,
    required this.button,
    required this.completer,
  });
}
