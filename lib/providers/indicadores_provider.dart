import 'package:flutter/material.dart';
import 'package:inmobiliariapp/components/indicador.dart';
import 'package:inmobiliariapp/components/tarjeta_indicador.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/grupo.dart';
import 'package:inmobiliariapp/model/user_model.dart';

class IndicadoresProvider with ChangeNotifier {
  List<Widget> indicadores = [
    /*const TarjetaIndicador(
      titulo: 'Llamada a cita cerrada',
      resultado: '135',
      indicador: Indicador(numeroPorcentual: 0.7, numeroEntero: 50),
    ),
    const TarjetaIndicador(
      titulo: 'De oferta a cierre',
      resultado: '122',
      indicador: Indicador(numeroPorcentual: 0.3, numeroEntero: 50),
    ),
    const TarjetaIndicador(
      titulo: '2a visita a exclusiva',
      resultado: '99',
      indicador: Indicador(numeroPorcentual: 0.45, numeroEntero: 50),
    ),
    const TarjetaIndicador(
      titulo: 'Llamada a exclusiva cerrada',
      resultado: '171',
      indicador: Indicador(numeroPorcentual: 0.9, numeroEntero: 50),
    ),*/
  ];
  UserModel user = UserModel('', '', '', '', '');
  Accion _accion = Accion('', Grupo('', ''));

  Accion get accion => _accion;
  int get size => indicadores.length;
  List<Widget> get list => indicadores;

  void setAccion(Accion accion) {
    _accion = accion;
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
