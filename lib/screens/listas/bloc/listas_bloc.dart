import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulist/models/lista_model/lista_model.dart';
import 'package:ulist/screens/listas/bloc/listas_event.dart';
import 'package:ulist/screens/listas/bloc/listas_repository.dart';
import 'package:ulist/screens/listas/bloc/listas_state.dart';

class ListasBloc extends Bloc<ListasEvent, ListasState> {
  final ListasRepository _repository = ListasRepository();
  late StreamSubscription<QuerySnapshot> subscription;

  ListasBloc() : super(ListasInitialState()) {
    final collectionRef = FirebaseFirestore.instance.collection('listas').orderBy('createdAt', descending: true);

    subscription = collectionRef.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        add(FetchListasEvent());
      }
    });

    on<FetchListasEvent>((event, emit) async {
      emit(ListasLoadingState());
      List<ListaModel> listas = await _repository.fetch();

      emit(ListasSuccessState(listas: listas));
    });

    on<SearchListasEvent>((event, emit) {
      List<ListaModel> listas = _repository.search(event.search);
      emit(ListasSuccessState(listas: listas));
    });

    on<CreateListasEvent>((event, emit) async {
      event.button.animate(loading: true);

      List<ListaModel> listas = await _repository.create(registro: event.registro);
      event.button.animate(loading: false);
      if (!event.completer.isCompleted) event.completer.complete();

      emit(ListasSuccessState(listas: listas));
    });

    on<UpdateListasEvent>((event, emit) async {
      event.button.animate(loading: true);

      List<ListaModel> listas = await _repository.update(lista: event.registro);

      event.button.animate(loading: false);
      if (!event.completer.isCompleted) event.completer.complete();
      
      emit(ListasSuccessState(listas: listas));
    });

    on<RemoveListasEvent>((event, emit) async {
      event.button.animate(loading: true);

      List<ListaModel> listas = await _repository.remove(lista: event.registro);
      emit(ListasSuccessState(listas: listas));

      event.button.animate(loading: false);
      if (!event.completer.isCompleted) event.completer.complete();
    });
  }
}
