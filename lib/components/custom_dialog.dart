import 'package:flutter/material.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/objetivo.dart';
import 'package:inmobiliariapp/providers/objetivos_provider.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/format_date.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

class CustomDialog extends StatefulWidget {
  final DateTime selectedDay;
  List<Accion> acciones;
  CustomDialog(this.selectedDay, this.acciones, {Key? key}) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  TextStyle style = TextStyle(
    color: colorNegro,
    fontSize: 45,
    fontWeight: FontWeight.w600,
  );

  List<Objetivo> objetivos = [];

  Future<void> getObjetivos() async {
    objetivos = await Database().getObjetivos(widget.selectedDay);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      content: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            height: 500,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
            ),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿Estás seguro/a?',
                      style: style, textAlign: TextAlign.center),
                  const SizedBox(height: 25),
                  Text('¡Esta acción es irreversible!',
                      style: style.copyWith(fontSize: 22),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 15),
                  Text('No podrás recuperar los objetivos borrados.',
                      style: style.copyWith(fontSize: 22),
                      textAlign: TextAlign.center),
                  const Spacer(),
                  botonesConfirmarCancelar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget botonesConfirmarCancelar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: colorBlanco,
            border: Border.all(color: colorGris, width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.circular(15),
            child: Ink(
              child: InkWell(
                onTap: () {
                  if (widget.acciones.isEmpty) {
                    return;
                  }
                  for (Accion accion in widget.acciones) {
                    if (accion.numero > 0) {
                      int max = getLastDayMonth(widget.selectedDay).day;
                      for (var i = 0; i < max; i++) {
                        var objetivo = Objetivo(
                          accion.nombre,
                          formatDate(getFirstDayMonth(widget.selectedDay)
                              .add(Duration(days: i))),
                          accion.numero,
                        );
                        context.read<ObjetivosProvider>().removeItem(objetivo);
                        Database().deleteObjetivo(objetivo);
                      }
                    }
                  }
                },
                child: Center(
                  child: Text(
                    'Confirmar',
                    style: TextStyle(color: colorNegro, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 50),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: colorBlanco,
            border: Border.all(color: colorGris, width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.circular(15),
            child: Ink(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: colorNegro, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
