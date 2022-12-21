import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Indicador extends StatefulWidget {
  final double max;
  final double initialValue;
  const Indicador({
    Key? key,
    required this.max,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<Indicador> createState() => _IndicadorState();
}

double roundDouble(double value, int places) {
  double mod = pow(10.0, places).toDouble();
  return ((value * mod).round().toDouble() / mod);
}

class _IndicadorState extends State<Indicador> {
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 100,
      animation: true,
      animationDuration: 500,
      lineWidth: 6.0,
      percent: widget.initialValue,
      progressColor: Theme.of(context).backgroundColor == colorNegro
          ? colorBlanco
          : colorNegro,
      arcType: ArcType.FULL,
      animateFromLastPercent: true,
      backgroundColor: Colors.transparent,
      arcBackgroundColor: Colors.transparent,
      center: Text('${roundDouble((widget.initialValue * 100), 2)}%',
          style: Theme.of(context).textTheme.headline3!.copyWith(
              color: Theme.of(context).backgroundColor == colorNegro
                  ? colorBlanco
                  : colorNegro)),
    );
  }
}