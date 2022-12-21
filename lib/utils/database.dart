import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/agencia.dart';
import 'package:inmobiliariapp/model/objetivo.dart';
import 'package:inmobiliariapp/model/user_model.dart';
import 'package:inmobiliariapp/utils/format_date.dart';

class Database {
  List<Accion> acciones = [];
  List<Accion> accionesJson = [];
  List<Agencia> agencias = [];
  List<Objetivo> objetivos = [];
  List<UserModel> agentes = [];
  List<UserModel> gerentes = [];
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.email;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserModel() async {
    var userModel = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((doc) => UserModel.fromDoc(doc));

    return userModel;
  }

  Future<List<UserModel>> getAgentes() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').get();
    var userModel = await getUserModel();

    agentes = snapshot.docs
        .where((doc) => doc['rol'].toLowerCase() == ('agente'))
        .where((doc) =>
            doc['agencia'].toLowerCase() == userModel.agencia.toLowerCase())
        .map((doc) => UserModel.fromDoc(doc))
        .toList();

    return agentes;
  }

  Future<List<UserModel>> getGerentes() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').get();
    var userModel = await getUserModel();

    gerentes = snapshot.docs
        .where((doc) => doc['rol'].toLowerCase() == ('gerente'))
        .where((doc) => doc['agencia']
            .toLowerCase()
            .contains(userModel.agencia.toLowerCase()))
        .map((doc) => UserModel.fromDoc(doc))
        .toList();

    return gerentes;
  }

  Future<List<Accion>> getAccionesUser() async {
    QuerySnapshot query = await firestore
        .collection('users')
        .doc(uid)
        .collection('acciones')
        .get();

    var acciones = query.docs.map((doc) => Accion.fromDoc(doc)).toList();
    for (var accion in acciones) {
      if (formatDate(accion.fecha) == formatDate(DateTime.now())) {
        accionesJson.add(accion);
      }
    }
    return accionesJson;
  }

  Future<List<Accion>> getAcciones() async {
    var data = await rootBundle.loadString('assets/acciones.json');
    var json = jsonDecode(data)['acciones'] as List;

    acciones = json.map((json) => Accion.fromJson(json)).toList();

    return acciones;
  }

  Future<void> addAcciones(Accion accion) async {
    debugPrint(uid);
    firestore
        .collection('users')
        .doc(uid)
        .collection('acciones')
        .doc(
            '${formatDate(DateTime.now())}_${accion.nombreGrupo}_${accion.nombre}')
        .set({
          'nombre': accion.nombre,
          'numero': accion.numero,
          'grupo': accion.grupo.nombre,
          'fecha': Timestamp.now(),
        })
        .then((value) =>
            debugPrint('nombre: ${accion.nombre}, numero: ${accion.numero}.'))
        .catchError((e) => {'No se ha podido añadir la acción.'});
  }

  Future<List<Objetivo>> getObjetivos(DateTime selectedDay) async {
    QuerySnapshot query = await firestore
        .collection('users')
        .doc(uid)
        .collection('objetivos')
        .where('fecha', isEqualTo: formatDate(selectedDay))
        .get();
    objetivos = query.docs.map((doc) => Objetivo.fromDoc(doc)).toList();
    return objetivos;
  }

  Future<List<Agencia>> getAgencias() async {
    QuerySnapshot query = await firestore.collection('agencias').get();

    agencias = query.docs.map((doc) => Agencia.fromDoc(doc)).toList();
    return agencias;
  }

  Future<void> deleteObjetivo(Objetivo objetivo) async {
    firestore
        .collection('users')
        .doc(uid)
        .collection('objetivos')
        .doc('${objetivo.nombre} - ${objetivo.fecha}')
        .delete();
  }

  Future<void> enviarObjetivos(Objetivo objetivo) async {
    firestore
        .collection('users')
        .doc(uid)
        .collection('objetivos')
        .doc('${objetivo.nombre} - ${objetivo.fecha}')
        .set(objetivo.createMap())
        .then((value) => debugPrint(objetivo.toString()))
        .catchError((e) => {debugPrint('No se ha podido añadir el objetivo.')});
  }

  Stream<QuerySnapshot> streamDataCollection(DateTime selectedDay) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('objetivos')
        .where('fecha', isEqualTo: formatDate(selectedDay))
        .snapshots();
  }
}
