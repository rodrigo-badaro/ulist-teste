import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulist/models/item_model/item_model.dart';
import 'package:ulist/models/lista_model/lista_model.dart';
import 'package:ulist/screens/listas/lista_detalhes_bloc/lista_detalhes_event.dart';
import 'package:ulist/screens/listas/lista_detalhes_bloc/lista_detalhes_repository.dart';
import 'package:ulist/screens/listas/lista_detalhes_bloc/lista_detalhes_state.dart';

class ListaDetalhesBloc extends Bloc<ListaDetalhesEvent, ListaDetalhesState> {
  final ListaDetalhesRepository _repository = ListaDetalhesRepository();
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;

  ListaDetalhesBloc() : super(ListaDetalhesInitialState()) {
    if (_repository.data != null) {
      final documentRef = FirebaseFirestore.instance.collection('listas').doc(_repository.data?.id);
      subscription = documentRef.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          add(FetchListaDetalhesEvent(
            ref: _repository.data?.id ?? '',
          ));
        }
      });
    }

    on<FetchListaDetalhesEvent>((event, emit) async {
      emit(ListaDetalhesLoadingState());
      ListaModel? lista = await _repository.fetch(ref: event.ref);

      emit(ListaDetalhesSuccessState(lista: lista));
    });

    on<SearchListaDetalhesEvent>((event, emit) {
      ListaModel? lista = _repository.search(event.search);
      emit(ListaDetalhesSuccessState(lista: lista));
    });

    on<CreateTarefaDetalhesEvent>((event, emit) async {
      event.button.animate(loading: true);

      ListaModel? lista = await _repository.create(registro: event.registro);

      event.button.animate(loading: false);
      if (!event.completer.isCompleted) event.completer.complete();

      emit(ListaDetalhesSuccessState(lista: lista));
    });

    on<UpdateTarefaDetalhesEvent>((event, emit) async {
      event.button.animate(loading: true);

      ListaModel? lista = await _repository.update(registro: event.registro);

      event.button.animate(loading: false);
      if (!event.completer.isCompleted) event.completer.complete();

      emit(ListaDetalhesSuccessState(lista: lista));
    });

    on<FinishTarefaDetalhesEvent>((event, emit) async {
      ListaModel? lista = _repository.data;
      List<ItemModel> items = lista?.items ?? [];

      if (items.isNotEmpty) {
        items.firstWhere((e) => e.id == event.registro.id).loading = true;
      }

      ListaModel? temp = lista?.copyWith(items: items);
      emit(ListaDetalhesSuccessState(lista: temp));

      lista = await _repository.finish(registro: event.registro);
      emit(ListaDetalhesSuccessState(lista: lista));
    });

    on<RemoveTarefaDetalhesEvent>((event, emit) async {
      if (event.registro != null) {
        event.button.animate(loading: true);

        ListaModel? lista = await _repository.remove(item: event.registro!);
        emit(ListaDetalhesSuccessState(lista: lista));

        event.button.animate(loading: false);
        if (!event.completer.isCompleted) event.completer.complete();
      }
    });
  }
}
