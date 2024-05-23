import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ulist/models/item_model/item_model.dart';
import 'package:ulist/models/lista_model/lista_model.dart';

class ListasRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ListaModel> _data = [];
  List<ListaModel> get data => _data;

  String _search = '';

  // Future<List<ListaModel>> fetch() async {
  //   List<ListaModel> listas = [];

  //   QuerySnapshot collection = await _firestore.collection('listas').get();

  //   for (QueryDocumentSnapshot doc in collection.docs) {
  //     Map<String, dynamic> listaDados = doc.data() as Map<String, dynamic>;

  //     ListaModel lista = ListaModel.fromMap({
  //       'id': doc.id,
  //       ...listaDados,
  //     });

  //     listas.add(lista);
  //   }

  //   _data = listas;

  //   return _data;
  // }

  Future<List<ListaModel>> fetch() async {
    List<ListaModel> listas = [];

    QuerySnapshot collection = await _firestore.collection('listas').get();

    for (QueryDocumentSnapshot doc in collection.docs) {
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

      ListaModel lista = ListaModel.fromMap(
        {
          'id': doc.id,
          'name': listaDados['name'],
          'description': listaDados['description'],
          'createdAt': listaDados['createdAt'],
          'updatedAt': listaDados['updatedAt'],
        },
        items,
      );

      listas.add(lista);
    }

    _data = listas;

    return _data;
  }

  List<ListaModel> search(String search) {
    _search = search;

    if (search.isEmpty) {
      return _data;
    }

    List<ListaModel> pesquisa = List.from(
      _data.where((element) =>
          element.name.toLowerCase().contains(_search.toLowerCase()) || //
          element.description.toLowerCase().contains(_search.toLowerCase())),
    );

    return pesquisa;
  }

  Future<List<ListaModel>> create({required ListaModel registro}) async {
    List<ListaModel> novaLista = List.from(_data);

    try {
      DocumentReference<Map<String, dynamic>> novoRegistro = await _firestore.collection('listas').add(registro.toMap());
      DocumentSnapshot<Map<String, dynamic>> novosDados = await novoRegistro.get();

      ListaModel novo = ListaModel.fromMap(
        {
          'id': novoRegistro.id,
          'name': novosDados['name'],
          'description': novosDados['description'],
          'createdAt': novosDados['createdAt'],
          'updatedAt': novosDados['updatedAt'],
        },
        [],
      );

      novaLista.add(novo);
    } catch (e) {
      debugPrint('Ocorreu um erro ao cadastrar uma nova lista => $e');
    }

    return novaLista;
  }

  Future<List<ListaModel>> update({required ListaModel lista}) async {
    DocumentReference listaRef = _firestore.collection('listas').doc(lista.id);
    DocumentSnapshot listaSnapshot = await listaRef.get();

    try {
      if (listaSnapshot.exists) {
        await listaRef.update({
          'name': lista.name,
          'description': lista.description,
          'updatedAt': Timestamp.now(),
        });
      } else {
        debugPrint('Lista "${lista.name}" não encontrada na base de dados.');
      }
    } catch (e) {
      debugPrint('Ocorreu um erro ao tentar alterar a lista ${lista.name} => $e');
    }

    List<ListaModel> novaLista = List.from(_data);
    int index = novaLista.indexWhere((element) => element.id == lista.id);

    novaLista[index] = lista;

    return novaLista;
  }

  Future<List<ListaModel>> remove({required ListaModel lista}) async {
    try {
      CollectionReference collection = _firestore.collection('listas');
      await collection.doc(lista.id).delete();
    } catch (e) {
      debugPrint('Ocorreu um erro ao tentar remover a lista ${lista.name} => $e');
    }

    List<ListaModel> novaLista = List.from(_data);
    novaLista.removeWhere((element) => element.id == lista.id);

    return novaLista;
  }
}
