import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/components/custom_button.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/grupo.dart';
import 'package:inmobiliariapp/model/objetivo.dart';
import 'package:inmobiliariapp/providers/objetivos_provider.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/format_date.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

class CustomListViewObjetivos extends StatefulWidget {
  final DateTime selectedDay;
  List<Accion> acciones = [];
  CustomListViewObjetivos(this.selectedDay, this.acciones, {Key? key})
      : super(key: key);

  @override
  State<CustomListViewObjetivos> createState() =>
      _CustomListViewObjetivosState();
}

Timer? _timer;
bool _longPressCanceled = false;

void _cancelIncrease() {
  if (_timer != null) {
    _timer!.cancel();
  }
  _longPressCanceled = true;
}

class _CustomListViewObjetivosState extends State<CustomListViewObjetivos> {
  List<Grupo> grupos = [];
  bool onHover = false;

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
                botonConfirmar(widget.acciones),
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
          icon: const Icon(FontAwesomeIcons.xmark, size: 20),
        ),
      ),
    );
  }

  Widget botonConfirmar(List<Accion> acciones) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
        child: AnimatedContainer(
          width: onHover ? 235 : 50,
          duration: const Duration(milliseconds: 250),
          child: Material(
            color: colorAzul,
            child: Ink(
              child: InkWell(
                onTap: () {
                  if (acciones.isEmpty) {
                    return;
                  }
                  for (Accion accion in acciones) {
                    if (accion.numero > 0) {
                      if (accion.semanaPressed) {
                        for (var i = 0; i < 7; i++) {
                          var objetivo = Objetivo(
                            accion.nombre,
                            formatDate(getMonday(widget.selectedDay)
                                .add(Duration(days: i))),
                            accion.numero,
                          );
                          context.read<ObjetivosProvider>().addItem(objetivo);
                          Database().enviarObjetivos(objetivo);
                        }
                      } else if (accion.mesPressed) {
                        int max = getLastDayMonth(widget.selectedDay).day;
                        for (var i = 0; i < max; i++) {
                          var objetivo = Objetivo(
                            accion.nombre,
                            formatDate(getFirstDayMonth(widget.selectedDay)
                                .add(Duration(days: i))),
                            accion.numero,
                          );
                          context.read<ObjetivosProvider>().addItem(objetivo);
                          Database().enviarObjetivos(objetivo);
                        }
                      } else {
                        var objetivo = Objetivo(
                          accion.nombre,
                          formatDate(widget.selectedDay),
                          accion.numero,
                        );
                        context.read<ObjetivosProvider>().addItem(objetivo);
                        Database().enviarObjetivos(objetivo);
                      }
                    }
                  }
                  Navigator.pop(context);
                },
                onHover: (o) => setState(() => onHover = o),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.check,
                          color: colorNegro,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'Confirmar objetivos',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(color: colorNegro),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                child: Row(
                  children: [
                    Expanded(child: texto(accion, context, i)),
                    botones(accion, context, i),
                  ],
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
          padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
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
              const SizedBox(width: 30),
              CustomButton(
                accion: accion[i],
                texto: 'S',
                onTap: () {
                  accion[i].setSemanaIsSelected(!accion[i].semanaPressed);
                  accion[i].setMesIsSelected(false);
                  setState(() {});
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              CustomButton(
                accion: accion[i],
                texto: 'M',
                onTap: () {
                  accion[i].setSemanaIsSelected(false);
                  accion[i].setMesIsSelected(!accion[i].mesPressed);
                  setState(() {});
                },
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              const SizedBox(width: 25),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox textoCentro(List<Accion> accion, int i) {
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
      height: 40,
      width: 40,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            child: Icon(
              Icons.add,
              size: 20,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            onTap: () {
              accion[i].setNumero(accion[i].numero + 1);
              setState(() {});
            },
            onLongPressEnd: (LongPressEndDetails details) {
              _cancelIncrease();
            },
            onLongPress: () {
              _longPressCanceled = false;
              Future.delayed(const Duration(milliseconds: 300), () {
                if (!_longPressCanceled) {
                  _timer =
                      Timer.periodic(const Duration(milliseconds: 15), (timer) {
                    accion[i].setNumero(accion[i].numero + 1);
                    setState(() {});
                  });
                }
              });
            },
            onLongPressUp: () {
              _cancelIncrease();
            },
            onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
              if (details.localOffsetFromOrigin.distance > 20) {
                _cancelIncrease();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget botonRestar(BuildContext context, List<Accion> accion, int i) {
    return Container(
      height: 40,
      width: 40,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Material(
        color: Colors.transparent,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            child: Icon(
              Icons.remove,
              size: 20,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            onTap: () {
              if (accion[i].numero > 0) {
                accion[i].setNumero(accion[i].numero - 1);
                setState(() {});
              }
            },
            onLongPressEnd: (LongPressEndDetails details) {
              _cancelIncrease();
            },
            onLongPress: () {
              _longPressCanceled = false;
              Future.delayed(const Duration(milliseconds: 300), () {
                if (!_longPressCanceled) {
                  _timer =
                      Timer.periodic(const Duration(milliseconds: 15), (timer) {
                    if (accion[i].numero > 0) {
                      accion[i].setNumero(accion[i].numero - 1);
                    }
                    setState(() {});
                  });
                }
              });
            },
            onLongPressUp: () {
              _cancelIncrease();
            },
            onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
              if (details.localOffsetFromOrigin.distance > 20) {
                _cancelIncrease();
              }
            },
          ),
        ),
      ),
    );
  }
}
