import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Comprueba si el tema del sistema operativo es oscuro o claro
class ThemeChecker {
  static Brightness brightness =
      SchedulerBinding.instance.window.platformBrightness;
  static bool isDarkMode = brightness == Brightness.dark;
}
