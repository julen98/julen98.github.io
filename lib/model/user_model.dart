import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email = '';
  String nombre = '';
  String rol = '';
  String foto = '';
  String agencia = '';

  UserModel(this.email, this.nombre, this.rol, this.foto, this.agencia);

  // Recibiendo datos desde el server
  factory UserModel.fromMap(map) {
    return UserModel(
      map['email'],
      map['nombre'],
      map['rol'],
      map['foto'],
      map['agencia'],
    );
  }

  // Recibir información desde un documento de Firestore
  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      doc.data().toString().contains('email') ? doc.get('email') : '',
      doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      doc.data().toString().contains('rol') ? doc.get('rol') : '',
      doc.data().toString().contains('foto') ? doc.get('foto') : '',
      doc.data().toString().contains('agencia') ? doc.get('agencia') : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  // Enviando datos al server
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombre': nombre,
      'rol': rol,
      'foto': foto,
      'agencia': agencia,
    };
  }

  @override
  String toString() =>
      'User(email: $email, nombre: $nombre, rol: $rol, agencia: $agencia)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.nombre == nombre &&
        other.rol == rol &&
        other.foto == foto &&
        other.agencia == agencia;
  }

  @override
  int get hashCode => Object.hash(email, nombre, rol, foto, agencia);
}
