import 'package:flutter/material.dart';
import 'package:inmobiliariapp/components/semaforo.dart';

class SemaforosProvider with ChangeNotifier {
  List<Semaforo> semaforos = [];

  void removeItem(Widget semaforo) {
    semaforos.remove(semaforo);
    notifyListeners();
  }
}
