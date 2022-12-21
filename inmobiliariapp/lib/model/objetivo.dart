import 'package:cloud_firestore/cloud_firestore.dart';

class Objetivo {
  String nombre = '';
  String date = '';
  int qty = 0;
  bool pressed = false;

  Objetivo(this.nombre, this.date, this.qty);

  String get fecha => date;
  int get cantidad => qty;
  bool get isSwitched => pressed;

  void setIsSwitched(bool value) {
    pressed = value;
  }

  Map<String, dynamic> createMap() {
    return {
      'nombre': nombre,
      'fecha': date,
      'cantidad': qty
    };
  }

  // Recibir información desde un documento de Firestore
  factory Objetivo.fromDoc(DocumentSnapshot doc) {
    return Objetivo(
      doc.data().toString().contains('nombre') ? doc.get('nombre') : '',
      doc.data().toString().contains('fecha') ? doc.get('fecha') : '',
      doc.data().toString().contains('cantidad') ? doc.get('cantidad') : 0,
    );
  }

  @override
  String toString() =>
      '\nObjetivo(nombre: $nombre, cantidad: $cantidad, fecha: $fecha)';
}
