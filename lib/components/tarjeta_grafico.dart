import 'package:flutter/material.dart';

class TarjetaGrafico extends StatefulWidget {
  final String title;
  final Widget grafico;
  const TarjetaGrafico({Key? key, required this.title, required this.grafico})
      : super(key: key);

  @override
  State<TarjetaGrafico> createState() => _TarjetaGraficoState();
}

class _TarjetaGraficoState extends State<TarjetaGrafico> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 350,
          minHeight: 350,
          maxHeight: 350,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(50),
          // border: Border.all(
          //   color: Theme.of(context).backgroundColor == colorNegro
          //       ? colorGrisOscuro
          //       : colorGrisMasClaro,
          //   width: 1.5,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.0),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Expanded(
              child: widget.grafico,
            ),
          ],
        ),
      ),
    );
  }
}
