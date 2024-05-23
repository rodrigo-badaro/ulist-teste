// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulist/models/item_model/item_model.dart';

class ListaModel {
  String? id;
  String name;
  String description;
  Timestamp createdAt;
  Timestamp updatedAt;
  List<ItemModel> items;

  ListaModel({
    this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  ListaModel copyWith({
    String? name,
    String? description,
    Timestamp? updatedAt,
    List<ItemModel>? items,
  }) {
    return ListaModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'createdAt': createdAt.toDate(),
      'updatedAt': updatedAt.toDate(),
    };
  }

  factory ListaModel.fromMap(Map<String, dynamic> map, List<ItemModel> items) {
    return ListaModel(
      id: map['id'],
      name: map['name'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      items: items,
    );
  }

  String toJson() => json.encode(toMap());

}
