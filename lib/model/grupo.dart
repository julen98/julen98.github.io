import 'package:cloud_firestore/cloud_firestore.dart';

class Grupo {
  String nombre = '';
  String nombre2 = '';
  int numero = 0;
  bool expanded = false;

  Grupo([
    this.nombre = '',
    this.nombre2 = '',
    this.numero = 0,
    this.expanded = false,
  ]);

  Map<String, dynamic> createMap() {
    return {
      'nombre': nombre,
      'nombre2': nombre2,
      'numero': numero,
    };
  }

  // Recibir información desde un documento de Firestore
  factory Grupo.fromDoc(DocumentSnapshot doc) {
    return Grupo(
      doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      doc.data().toString().contains('nombre2') ? doc.get('grupo2') : '',
      doc.data().toString().contains('numero') ? doc.get('numero') : 0,
    );
  }

  factory Grupo.fromJson(dynamic json) {
    return Grupo(
      json['nombre'] as String,
      json['nombre2'] as String,
      json['numero'] as int,
    );
  }

  @override
  String toString() =>
      'Grupo(nombre: $nombre, nombre2: $nombre2, numero: $numero)';
}
