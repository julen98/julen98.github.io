import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/grupo.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class CustomListViewAcciones extends StatefulWidget {
  final List<Accion> acciones;
  const CustomListViewAcciones({Key? key, required this.acciones})
      : super(key: key);

  @override
  State<CustomListViewAcciones> createState() => _CustomListViewAccionesState();
}

class _CustomListViewAccionesState extends State<CustomListViewAcciones> {
  List<Grupo> grupos = [];
  List<Accion> accionesFirestore = [];

  Future<void> getAcciones() async {
    accionesFirestore = await Database().getAccionesUser();
  }

  @override
  void initState() {
    fetchGrupos(widget.acciones);
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
    getAcciones();

    for (var accion in widget.acciones) {
      if (accion.grupo.nombre == grupo.nombre) {
        acciones.add(accion);
      }
    }

    for (var accionFirestore in accionesFirestore) {
      for (var accion in acciones) {
        if (accion.nombre == accionFirestore.nombre) {
          accion.setNumero(accion.numero + accionFirestore.numero);
        }
      }
    }

    return acciones;
  }

  List<Grupo> fetchGrupos(List<Accion> acciones) {
    for (var i = 0; i < acciones.length; i++) {
      if ((i - 1) > 0) {
        if (acciones[i - 1].grupo.nombre != acciones[i].grupo.nombre) {
          grupos.add(acciones[i].grupo);
        }
      }
    }
    debugPrint(grupos.toString());
    return grupos;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return grupos.isEmpty || widget.acciones.isEmpty
        ? SpinKitRing(color: colorAzul, lineWidth: 4)
        : Container(
            color: Theme.of(context).backgroundColor == colorNegro
                ? colorGrisOscuro
                : colorGrisClaro,
            width: 1000,
            child: Material(
              color: Theme.of(context).backgroundColor,
              child: ListView.builder(
                primary: false,
                itemCount: grupos.length,
                itemBuilder: (context, i) {
                  return ExpansionTile(
                    subtitle: grupos[i].nombre2.isNotEmpty
                        ? Text(grupos[i].nombre2,
                            style: Theme.of(context).textTheme.subtitle2)
                        : null,
                    collapsedBackgroundColor:
                        Theme.of(context).backgroundColor == colorNegro
                            ? colorGrisOscuro
                            : colorGrisMasClaro,
                    backgroundColor:
                        Theme.of(context).backgroundColor == colorNegro
                            ? colorGrisMasOscuro
                            : colorGrisClaro,
                    tilePadding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    title: Row(
                      children: [
                        Text(grupos[i].nombre),
                        const Spacer(),
                        Text('${sumatoria(i)}'),
                        const SizedBox(width: 25),
                      ],
                    ),
                    children: [
                      Material(
                        color: Theme.of(context).backgroundColor,
                        child: listaExpansion(fetchAcciones(grupos[i])),
                      ),
                    ],
                  );
                },
              ),
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
          icon: const Icon(FontAwesomeIcons.xmark, size: 20),
        ),
      ),
    );
  }

  Widget listaExpansion(List<Accion> accion) {
    return Container(
      color: Theme.of(context).backgroundColor == colorNegro
          ? colorGrisOscuro
          : colorGrisClaro,
      height: 400,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: accion.length,
        itemBuilder: (context, i) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: Responsive.isDesktop(context) ? 1000 : 400),
              child: IntrinsicWidth(
                child: Row(
                  children: [
                    Expanded(child: texto(accion, context, i)),
                    botones(accion, context, i),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget texto(List<Accion> accion, BuildContext context, int i) {
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

  Widget botones(List<Accion> accion, BuildContext context, int i) {
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
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              botonRestar(context, accion, i),
              const SizedBox(width: 10),
              textoCentro(accion, i),
              const SizedBox(width: 10),
              botonSumar(context, accion, i),
              const SizedBox(width: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget textoCentro(List<Accion> accion, int i) {
    return SizedBox(
      height: 40,
      child: Center(
        child: IntrinsicWidth(
          child: Container(
            constraints: const BoxConstraints(minWidth: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: colorGris, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 6, 5, 8),
              child: Center(child: Text('${accion[i].numero}')),
            ),
          ),
        ),
      ),
    );
  }

  Widget botonSumar(BuildContext context, List<Accion> accion, int i) {
    return Container(
      height: 35,
      width: 35,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(
            Icons.add,
            size: 20,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onPressed: () {
            accion[i].setNumero(accion[i].numero + 1);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget botonRestar(BuildContext context, List<Accion> accion, int i) {
    return Container(
      height: 35,
      width: 35,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(
            Icons.remove,
            size: 20,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onPressed: () {
            if (accion[i].numero > 0) {
              accion[i].setNumero(accion[i].numero - 1);
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}
