import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inmobiliariapp/utils/format_date.dart';

import 'grupo.dart';

class Accion {
  String _nombre = '';
  int _numero = 0;
  String _grupo = '';
  String _grupo2 = '';
  Grupo _grupoObjeto = Grupo('', '');
  Timestamp _fecha = Timestamp(0, 0);
  bool _semanaIsSelected = false;
  bool _mesIsSelected = false;
  bool _yearIsSelected = false;
  bool _expanded = false;
  TextEditingController controller = TextEditingController();

  Accion(
    this._nombre,
    this._grupoObjeto, [
    this._numero = 0,
    Timestamp? fecha,
  ]) : _fecha = fecha ?? Timestamp.now();

  String get nombre => _nombre;
  int get numero => _numero;
  Grupo get grupo => _grupoObjeto;
  String get nombreGrupo => _grupo;
  String get nombreGrupo2 => _grupo2;
  DateTime get fecha => _fecha.toDate();
  bool get semanaPressed => _semanaIsSelected;
  bool get mesPressed => _mesIsSelected;
  bool get yearPressed => _yearIsSelected;
  bool get expanded => _expanded;
  TextEditingController get getController => controller;

  void setNombre(String s) => _nombre = s;
  void setNumero(int i) => _numero = i;
  void setGrupo(Grupo g) => _grupoObjeto = g;
  void setFecha(Timestamp t) => _fecha = t;
  void setSemanaIsSelected(bool b) => _semanaIsSelected = b;
  void setMesIsSelected(bool b) => _mesIsSelected = b;
  void setYearIsSelected(bool b) => _yearIsSelected = b;
  void setExpanded(bool b) => _expanded = b;
  void setController(String s) => controller.text = s;

  Map<String, dynamic> createMap() {
    return {
      'nombre': nombre,
      'numero': numero,
      'grupo': nombreGrupo,
      'grupo2': nombreGrupo2,
      'fecha': fecha,
    };
  }

  // Recibir información desde un documento de Firestore
  factory Accion.fromDoc(DocumentSnapshot doc) {
    return Accion(
      doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      Grupo(
        doc.data().toString().contains('grupo') ? doc.get('grupo') : '',
        doc.data().toString().contains('grupo2') ? doc.get('grupo2') : '',
      ),
      doc.data().toString().contains('numero') ? doc.get('numero') : 0,
      doc.data().toString().contains('fecha')
          ? doc.get('fecha')
          : Timestamp(0, 0),
    );
  }

  factory Accion.fromJson(dynamic json) {
    return Accion(
      json['nombre'] as String,
      Grupo(json['grupo'] as String, json['grupo2'] as String),
    );
  }

  @override
  String toString() => 'Accion(nombre: $_nombre, numero: $numero, '
      'grupo: $_grupo, fecha: ${formatDate(_fecha.toDate())})';
}
