import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:ulist/get_it.dart';
import 'package:ulist/models/item_model/item_model.dart';
import 'package:ulist/models/lista_model/lista_model.dart';
import 'package:ulist/screens/listas/bloc/listas_bloc.dart';

class ListaDetalhesRepository {
  final ListasBloc listasBloc = getIt<ListasBloc>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ListaModel? _data;
  ListaModel? get data => _data;

  String _search = '';

  Future<ListaModel?> fetch({required String ref, bool forceFetch = false}) async {
    _data = listasBloc.state.listas.firstWhereOrNull((e) => e.id == ref);

    if (_data == null || forceFetch) {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('listas').doc(ref).get();

      Map<String, dynamic> listaDados = doc.data() as Map<String, dynamic>;

      List<ItemModel> items = [];
      QuerySnapshot itemsSnapshot = await doc.reference.collection('items').get();

      for (QueryDocumentSnapshot itemDoc in itemsSnapshot.docs) {
        Map<String, dynamic> itemDados = itemDoc.data() as Map<String, dynamic>;

        ItemModel item = ItemModel.fromMap({
          'id': itemDoc.id,
          ...itemDados,
        });

        items.add(item);
      }

      _data = ListaModel.fromMap(
        {
          'id': doc.id,
          'name': listaDados['name'],
          'description': listaDados['description'],
          'createdAt': listaDados['createdAt'],
          'updatedAt': listaDados['updatedAt'],
        },
        items,
      );
    }

    return _data;
  }

  ListaModel? search(String search) {
    _search = search;

    if (search.isEmpty) {
      return _data;
    }

    List<ItemModel> items = _data?.items
            .where((element) =>
                    element.name.toLowerCase().contains(_search.toLowerCase()) || //
                    element.description.toLowerCase().contains(_search.toLowerCase()) //
                )
            .toList() ??
        [];

    ListaModel? pesquisa = _data?.copyWith(items: items);

    return pesquisa;
  }

  Future<ListaModel?> create({required ItemModel registro}) async {
    try {
      if (_data != null) {
        await _firestore.collection('listas').doc(_data?.id).collection('items').add(registro.toMap());
      }
    } catch (e) {
      debugPrint('Ocorreu um erro ao cadastrar uma nova lista => $e');
    }

    return fetch(ref: _data?.id ?? '', forceFetch: true);
  }

  Future<ListaModel?> update({required ItemModel registro}) async {
    DocumentReference listaRef = _firestore.collection('listas').doc(_data?.id).collection('items').doc(registro.id);
    DocumentSnapshot listaSnapshot = await listaRef.get();

    try {
      if (listaSnapshot.exists) {
        await listaRef.update({
          'name': registro.name,
          'description': registro.description,
          'data': registro.data,
          'horario': registro.horario,
          'completed': registro.completed,
          'updatedAt': Timestamp.now(),
        });
      } else {
        debugPrint('Tarefa "${registro.name}" não encontrada na base de dados.');
      }
    } catch (e) {
      debugPrint('Ocorreu um erro ao tentar alterar a tarefa ${registro.name} => $e');
    }

    return fetch(ref: _data?.id ?? '', forceFetch: true);
  }

  Future<ListaModel?> finish({required ItemModel registro}) async {
    DocumentReference listaRef = _firestore.collection('listas').doc(_data?.id).collection('items').doc(registro.id);
    DocumentSnapshot listaSnapshot = await listaRef.get();

    try {
      if (listaSnapshot.exists) {
        await listaRef.update({
          'completed': registro.completed,
          'updatedAt': Timestamp.now(),
        });
      } else {
        debugPrint('Tarefa "${registro.name}" não encontrada na base de dados.');
      }
    } catch (e) {
      debugPrint('Ocorreu um erro ao tentar alterar concluir a tarefa ${registro.name} => $e');
    }

    return fetch(ref: _data?.id ?? '', forceFetch: true);
  }

  Future<ListaModel?> remove({required ItemModel item}) async {
    try {
      CollectionReference collection = _firestore.collection('listas').doc(_data?.id).collection('items');
      await collection.doc(item.id).delete();
    } catch (e) {
      debugPrint('Ocorreu um erro ao tentar remover a tarefa ${item.name} => $e');
    }

    return fetch(ref: _data?.id ?? '', forceFetch: true);
  }
}
