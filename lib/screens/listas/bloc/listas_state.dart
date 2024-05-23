import 'package:ulist/models/lista_model/lista_model.dart';

abstract class ListasState {
  List<ListaModel> listas = [];

  ListasState({
    required this.listas,
  });
}

class ListasInitialState extends ListasState {
  ListasInitialState() : super(listas: []);
}

class ListasLoadingState extends ListasState {
  ListasLoadingState() : super(listas: []);
}

class ListasSuccessState extends ListasState {
  ListasSuccessState({required super.listas});
}
