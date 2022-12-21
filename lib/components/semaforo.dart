import 'package:flutter/material.dart';

class Semaforo extends StatefulWidget {
  final int diasCumplidos;
  final String semaforo;
  const Semaforo(
      {Key? key, required this.diasCumplidos, required this.semaforo})
      : super(key: key);

  @override
  State<Semaforo> createState() => _SemaforoState();
}

class _SemaforoState extends State<Semaforo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.5,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: switchSemaforo(),
      ),
    );
  }

  Widget switchSemaforo() {
    switch (widget.semaforo) {
      case 'verde':
        return semaforoVerde();
      case 'amarillo':
        return semaforoAmarillo();
      case 'rojo':
        return semaforoRojo();
      default:
        return const SizedBox(
          child: Text(
            'Ha ocurrido un error inesperado.\n'
            'Si el error persiste, póngase en contacto con soporte.',
          ),
        );
    }
  }

  Widget semaforoVerde() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.5,
      child: AnimatedSwitcher(
        key: UniqueKey(),
        duration: const Duration(milliseconds: 200),
        child: widget.diasCumplidos >= 4
            ? Image.asset(
                'assets/images/semaforoVerdeGif.gif',
                width: MediaQuery.of(context).size.width / 3,
              )
            : Image.asset(
                'assets/images/verde_off.png',
                width: MediaQuery.of(context).size.width / 3,
              ),
      ),
    );
  }

  Widget semaforoAmarillo() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.5,
      child: AnimatedSwitcher(
        key: UniqueKey(),
        duration: const Duration(milliseconds: 200),
        child: widget.diasCumplidos == 2 || widget.diasCumplidos == 3
            ? Image.asset(
                'assets/images/semaforoAmarilloGif.gif',
                width: MediaQuery.of(context).size.width / 3,
              )
            : Image.asset(
                'assets/images/amarillo_off.png',
                width: MediaQuery.of(context).size.width / 3,
              ),
      ),
    );
  }

  Widget semaforoRojo() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.5,
      child: AnimatedSwitcher(
        key: UniqueKey(),
        duration: const Duration(milliseconds: 200),
        child: widget.diasCumplidos <= 1
            ? Image.asset(
                'assets/images/semaforoRojoGif.gif',
                width: MediaQuery.of(context).size.width / 3,
              )
            : Image.asset(
                'assets/images/rojo_off.png',
                width: MediaQuery.of(context).size.width / 3,
              ),
      ),
    );
  }
}
