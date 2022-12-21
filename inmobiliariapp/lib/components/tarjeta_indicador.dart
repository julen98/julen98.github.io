import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/providers/indicadores_provider.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

import 'detalles_indicador.dart';

class TarjetaIndicador extends StatefulWidget {
  final Color? color;
  final String titulo;
  final String resultado;
  final double? width;
  final Widget indicador;

  const TarjetaIndicador({
    Key? key,
    this.color,
    required this.titulo,
    required this.resultado,
    this.width,
    required this.indicador,
  }) : super(key: key);

  @override
  State<TarjetaIndicador> createState() => _TarjetaIndicadorState();
}

class _TarjetaIndicadorState extends State<TarjetaIndicador> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? (SizeConfig.width <= 850 ? double.infinity : 450),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          colors: [colorAzul, colorRosa],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.transparent,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Ink(
          child: InkWell(
            splashColor: const Color.fromARGB(24, 255, 255, 255),
            onTap: () {
              /*showDialog(
                context: context,
                builder: (context) {
                  return const DetallesIndicador();
                },
              );*/
            },
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.xmark,
                      ),
                      splashRadius: 25,
                      color: colorBlanco,
                      onPressed: () {
                        context.read<IndicadoresProvider>().removeItem(widget);
                      },
                    ),
                  ),
                  SizedBox(height: SizeConfig.paddingVertical),
                  widget.indicador,
                  SizedBox(height: SizeConfig.paddingVertical),
                  Text(
                    widget.resultado,
                    style: TextStyle(
                      color: colorBlanco,
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.titulo,
                    style: TextStyle(
                      color: colorBlanco,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: SizeConfig.paddingVertical),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
