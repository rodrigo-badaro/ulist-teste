import 'package:ulist/models/lista_model/lista_model.dart';

abstract class ListaDetalhesState {
  ListaModel? lista;

  ListaDetalhesState({
    required this.lista,
  });
}

class ListaDetalhesInitialState extends ListaDetalhesState {
  ListaDetalhesInitialState() : super(lista: null);
}

class ListaDetalhesLoadingState extends ListaDetalhesState {
  ListaDetalhesLoadingState() : super(lista: null);
}

class ListaDetalhesSuccessState extends ListaDetalhesState {
  ListaDetalhesSuccessState({required super.lista});
}
