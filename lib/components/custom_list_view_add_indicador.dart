import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/grupo.dart';
import 'package:inmobiliariapp/providers/indicadores_provider.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

class CustomListViewAddIndicador extends StatefulWidget {
  final List<Accion> acciones;
  const CustomListViewAddIndicador({Key? key, required this.acciones})
      : super(key: key);

  @override
  State<CustomListViewAddIndicador> createState() =>
      _CustomListViewAddIndicadorState();
}

class _CustomListViewAddIndicadorState
    extends State<CustomListViewAddIndicador> {
  List<Grupo> grupos = [];

  @override
  void initState() {
    fetchGrupos();
    super.initState();
  }

  // Metodo para saber cuantas filas son marcadas
  int sumatoria(i) {
    int sumatoria = 0;
    for (var j = 0; j < widget.acciones.length; j++) {
      if (widget.acciones[j].grupo.nombre == grupos[i].nombre) {
        sumatoria += widget.acciones[j].numero;
      }
    }
    return sumatoria;
  }

  List<Accion> fetchAcciones(Grupo grupo) {
    List<Accion> acciones = [];

    for (var accion in widget.acciones) {
      if (accion.grupo.nombre == grupo.nombre) {
        acciones.add(accion);
      }
    }

    return acciones;
  }

  List<Grupo> fetchGrupos() {
    for (var i = 0; i < widget.acciones.length; i++) {
      if ((i - 1) > 0) {
        if (widget.acciones[i - 1].grupo.nombre !=
            widget.acciones[i].grupo.nombre) {
          grupos.add(widget.acciones[i].grupo);
        }
      }
    }
    return grupos;
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
      content: grupos.isEmpty || widget.acciones.isEmpty
          ? SpinKitRing(color: colorAzul, lineWidth: 4)
          : Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    botonSalir(),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 1000
                          : SizeConfig.width * 0.9,
                      height: 600,
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(15),
                        child: Material(
                          color: Theme.of(context).backgroundColor == colorNegro
                              ? colorGrisOscuro
                              : colorGrisMasClaro,
                          child: ListView.builder(
                            itemCount: grupos.length,
                            itemBuilder: (context, i) {
                              return ExpansionTile(
                                tilePadding:
                                    const EdgeInsets.fromLTRB(25, 10, 25, 10),
                                title: Text(grupos[i].nombre),
                                children: [
                                  Material(
                                    color: Theme.of(context).backgroundColor,
                                    child: listaExpansion(
                                        fetchAcciones(grupos[i])),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget botonSalir() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 1),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 20,
          icon: Icon(
            FontAwesomeIcons.xmark,
            size: 20,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
      ),
    );
  }

  Widget listaExpansion(List<Accion> accion) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: accion.length,
      itemBuilder: (context, i) {
        return Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: Responsive.isDesktop(context)
                    ? 1000
                    : SizeConfig.width * 0.9,
              ),
              child: IntrinsicWidth(
                child: Ink(
                  child: InkWell(
                    splashColor: const Color.fromARGB(40, 255, 255, 255),
                    onTap: () {
                      context.read<IndicadoresProvider>().setAccion(accion[i]);
                      debugPrint(context.read<IndicadoresProvider>().accion.toString());
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Expanded(child: texto(accion, context, i)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container texto(List<Accion> accion, BuildContext context, int i) {
    return Container(
      decoration: BoxDecoration(
        border: accion.length > 1
            ? Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? colorGrisOscuro
                      : colorGrisClaro,
                ),
              )
            : null,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 15, 25, 15),
          child: SizedBox(
            child: Text(accion[i].nombre, overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    );
  }
}
