import 'package:flutter/material.dart';
import 'package:inmobiliariapp/model/objetivo.dart';
import 'package:inmobiliariapp/utils/database.dart';

class ObjetivosProvider with ChangeNotifier {
  final Database _db = Database();
  List<Objetivo> objetivos = [];

  List<Objetivo> get list => objetivos;

  void setList(List<Objetivo> objetivos) {
    this.objetivos = objetivos;
    notifyListeners();
  }

  void addItem(Objetivo objetivo) {
    objetivos.add(objetivo);
    notifyListeners();
  }

  void removeItem(Objetivo objetivo) {
    objetivos.remove(objetivo);
    notifyListeners();
  }

  Future<List<Objetivo>> fetchObjetivos(selectedDay) async {
    objetivos = await _db.getObjetivos(selectedDay);
    notifyListeners();
    return objetivos;
  }

  fetchObjetivosStream(DateTime selectedDay) {
    return _db.streamDataCollection(selectedDay);
  }
}
