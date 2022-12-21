import 'package:flutter/material.dart';

class AccionesProvider with ChangeNotifier {
  List<Widget> indicadores = [];

  int get size => indicadores.length;
  List<Widget> get list => indicadores;

  void addItem(Widget tarjetaIndicador) {
    indicadores.add(tarjetaIndicador);
    notifyListeners();
  }

  void removeItem(Widget tarjetaIndicador) {
    indicadores.remove(tarjetaIndicador);
    notifyListeners();
  }
}
