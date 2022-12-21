import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inmobiliariapp/utils/format_date.dart';

import 'accion.dart';
import 'grupo.dart';

class Conversion {
  String _nombre = '';
  Accion _accion1 = Accion('', Grupo(''));
  Accion _accion2 = Accion('', Grupo(''));
  int _numero = 0;
  Timestamp _fecha = Timestamp(0, 0);

  Conversion(
    this._nombre,
    this._accion1,
    this._accion2, [
    this._numero = 0,
    Timestamp? fecha,
  ]) : _fecha = fecha ?? Timestamp.now();

  String get nombre => _nombre;
  Accion get accion1 => _accion1;
  Accion get accion2 => _accion2;
  int get numero => _numero;
  DateTime get fecha => _fecha.toDate();

  void setNombre(String s) => _nombre = s;
  void setAccion1(Accion a1) => _accion1 = a1;
  void setAccion2(Accion a2) => _accion2 = a2;
  void setNumero(int i) => _numero = i;
  void setFecha(Timestamp t) => _fecha = t;

  Map<String, dynamic> createMap() {
    return {
      'nombre': nombre,
      'accion1': accion1,
      'accion2': accion2,
      'numero': numero,
      'fecha': fecha,
    };
  }

  // Recibir información desde un documento de Firestore
  factory Conversion.fromDoc(DocumentSnapshot doc) {
    return Conversion(
      doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      doc.data().toString().contains('accion1') ? doc.get('accion1') : '',
      doc.data().toString().contains('accion2') ? doc.get('accion2') : '',
      doc.data().toString().contains('numero') ? doc.get('numero') : 0,
      doc.data().toString().contains('fecha')
          ? doc.get('fecha')
          : Timestamp(0, 0),
    );
  }

  factory Conversion.fromJson(dynamic json) {
    return Conversion(
      json['nombre'] as String,
      json['accion1'] as Accion,
      json['accion2'] as Accion,
    );
  }

  @override
  String toString() =>
      'Conversion(nombre: $_nombre, accion1: $_accion1, accion2: $_accion2, numero: $numero, '
      'fecha: ${formatDate(_fecha.toDate())})';
}
