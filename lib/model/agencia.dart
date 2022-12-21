import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inmobiliariapp/model/user_model.dart';

class Agencia {
  String nombre = '';
  List<UserModel> agentes = [];
  List<UserModel> gerentes = [];
  String foto = 'vacio';
  String direccion = '';
  int numeroEmpleados = 0;

  Agencia(
    this.nombre, [
    this.agentes = const [],
    this.gerentes = const [],
    this.foto = '',
  ]);

  // Recibiendo datos desde el server
  factory Agencia.fromMap(map) {
    return Agencia(
      map['nombre'],
      map['agentes'],
      map['gerentes'],
      map['foto'],
    );
  }

  // Recibir información desde un documento de Firestore
  factory Agencia.fromDoc(DocumentSnapshot doc) {
    return Agencia(
      doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      doc.data().toString().contains('agentes') ? doc.get('agentes') : [],
      doc.data().toString().contains('gerentes') ? doc.get('gerentes') : [],
      doc.data().toString().contains('foto') ? doc.get('foto') : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Agencia.fromJson(String source) =>
      Agencia.fromMap(json.decode(source));

  // Enviando datos al server
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    };
  }

  @override
  String toString() => 'Agencia(nombre: $nombre)';
}
