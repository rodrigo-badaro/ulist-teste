import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String? id;
  String name;
  String description;
  Timestamp data;
  String? horario;
  Timestamp createdAt;
  Timestamp updatedAt;
  bool completed;
  bool loading;

  ItemModel({
    this.id,
    required this.name,
    required this.description,
    required this.data,
    this.horario,
    required this.createdAt,
    required this.updatedAt,
    required this.completed,
    this.loading = false,
  });

  ItemModel copyWith({
    String? name,
    String? description,
    Timestamp? updatedAt,
    Timestamp? data,
    String? horario,
    bool? completed,
  }) {
    return ItemModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      data: data ?? this.data,
      horario: horario ?? this.horario,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'data': data.toDate(),
      'horario': horario,
      'createdAt': createdAt.toDate(),
      'updatedAt': updatedAt.toDate(),
      'completed': completed,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      name: map['name'] as String,
      description: map['description'] as String,
      data: map['data'],
      horario: map['horario'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      completed: map['completed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) => ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
