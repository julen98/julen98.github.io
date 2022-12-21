import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final Widget smallMobile;

  const Responsive({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    required this.smallMobile
  }) : super(key: key);

  // Metodos estaticos para saber si es movil, tablet o PC
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1200 &&
      MediaQuery.of(context).size.width >= 768;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // Si es mas de 1200 es pc
    if (_size.width >= 1200) {
      return desktop;
    }
    // Si es menos de 1200 y mas de 768 es tablet
    else if (_size.width >= 768) {
      return tablet;
    }
    // Menos de 768 es un movil y menos de 376 es un movil pequeño
    else if (_size.width >= 376 && _size.width <= 768) {
      return mobile;
    } else {
      return smallMobile;
    }
  }
}