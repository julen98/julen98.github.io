import 'package:flutter/material.dart';
import 'package:inmobiliariapp/components/indicador.dart';
import 'package:inmobiliariapp/components/tarjeta_indicador.dart';
import 'package:inmobiliariapp/model/conversion.dart';
import 'package:inmobiliariapp/model/grupo.dart';
import 'package:inmobiliariapp/model/user_model.dart';

class ConversionesProvider with ChangeNotifier {
  List<Widget> indicadores = [];
  UserModel user = UserModel('', '', '', '', '');
  String _conversion = '';

  String get conversion => _conversion;
  int get size => indicadores.length;
  List<Widget> get list => indicadores;

  void setConversion(String conversion) {
    _conversion = conversion;
    notifyListeners();
  }

  void setUser(UserModel user) {
    this.user = user;
    notifyListeners();
  }

  void addItem(Widget tarjetaIndicador) {
    indicadores.add(tarjetaIndicador);
    notifyListeners();
  }

  void clear(Widget tarjetaIndicador) {
    indicadores.clear();
    notifyListeners();
  }

  void removeItem(Widget tarjetaIndicador) {
    indicadores.remove(tarjetaIndicador);
    notifyListeners();
  }
}
