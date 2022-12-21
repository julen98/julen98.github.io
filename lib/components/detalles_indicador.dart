import 'package:flutter/material.dart';
import 'package:inmobiliariapp/components/grafico_barras.dart';

class DetallesIndicador extends StatelessWidget {
  const DetallesIndicador({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      content: Builder(
        builder: (context) {
          return SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Vista detallada',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Contenido'),
                ),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ventas',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: GraficoBarras(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
