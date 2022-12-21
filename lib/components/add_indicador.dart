import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/components/custom_toggle_button.dart';
import 'package:inmobiliariapp/components/tarjeta_indicador.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/cabecera.dart';
import 'package:inmobiliariapp/model/contenido.dart';
import 'package:inmobiliariapp/model/grupo.dart';
import 'package:inmobiliariapp/providers/indicadores_provider.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

import 'custom_list_view_add_indicador.dart';
import 'indicador.dart';

class AddIndicador extends StatefulWidget {
  const AddIndicador({Key? key}) : super(key: key);

  @override
  State<AddIndicador> createState() => _AddIndicadorState();
}

String rango = '';
String? texto;
String? simboloResultado;
double? size = 22;

// Lista formato resultado
List<Cabecera> formato = [
  Cabecera('Moneda', monedas),
  Cabecera('Número', numeros)
];
List<Contenido> monedas = [
  Contenido('Euro', Icon(FontAwesomeIcons.euroSign, size: size), '€'),
  Contenido('Dólar/Peso', Icon(FontAwesomeIcons.dollarSign, size: size), '\$'),
  Contenido('Libra', Icon(FontAwesomeIcons.sterlingSign, size: size), '£'),
];
List<Contenido> numeros = [
  Contenido('Sin decimales', const Icon(Icons.numbers), '€'),
  Contenido('1 decimal', const Icon(Icons.numbers), '\$'),
  Contenido('2 decimales', const Icon(Icons.numbers), '£'),
  Contenido('3+ decimales', const Icon(Icons.numbers), '£'),
];

late Accion totalSemana;
List<Accion> listaTotalSemana = [];
List<Accion> totalMes = [];
List<Accion> totalTrimestre = [];
List<Accion> totalAnual = [];
late List<Accion> accionesFirestore;
List<Accion> acciones = [];

final formKey = GlobalKey<FormState>();

class _AddIndicadorState extends State<AddIndicador> {
  Future<void> getAcciones() async {
    acciones = await Database().getAcciones();
  }

  Future<void> getData() async {
    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(context.read<IndicadoresProvider>().user.email)
        .collection('acciones')
        .get();

    accionesFirestore = doc.docs.map((doc) => Accion.fromDoc(doc)).toList();
  }

  void treatData() {
    int numero = 0;
    String nombre = '';
    Grupo grupo = Grupo();
    Timestamp fecha = Timestamp.now();
    Accion accion = context.read<IndicadoresProvider>().accion;

    for (int i = 0; i < accionesFirestore.length; i++) {
      if (accionesFirestore[i].nombre == accion.nombre) {
        listaTotalSemana.add(accionesFirestore[i]);
      }
    }

    for (int i = 0; i < listaTotalSemana.length; i++) {
      if (listaTotalSemana[i].grupo.nombre == accion.grupo.nombre &&
          listaTotalSemana[i].nombre == accion.nombre) {
        numero += listaTotalSemana[i].numero;
        nombre = listaTotalSemana[i].nombre;
        grupo = listaTotalSemana[i].grupo;
        fecha = Timestamp.fromDate(listaTotalSemana[i].fecha);
      }
    }

    totalSemana = Accion(nombre, grupo, numero, fecha);
  }

  @override
  void initState() {
    super.initState();
    getAcciones();
    getData();
  }

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
      content: Builder(builder: (context) {
        return SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Añadir indicador',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              // const SizedBox(height: 50),
              // resultadoField(),
              const SizedBox(height: 35),
              Row(
                children: [
                  CustomToggleButton(),
                ],
              ),
              const SizedBox(height: 35),
              botonAcciones(),
              const SizedBox(height: 35),
              botonesConfirmarCancelar(context),
            ],
          ),
        );
      }),
    );
  }

  Widget botonesConfirmarCancelar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          color: Colors.green,
          highlightColor: const Color.fromARGB(45, 76, 175, 80),
          hoverColor: const Color.fromARGB(30, 76, 175, 80),
          splashColor: const Color.fromARGB(60, 76, 175, 80),
          splashRadius: 25,
          onPressed: () {
            treatData();
            if (totalSemana.numero > 0) {
              context.read<IndicadoresProvider>().addItem(
                    TarjetaIndicador(
                      titulo: totalSemana.nombre,
                      resultado: '${totalSemana.numero}',
                      indicador: Indicador(
                        initialValue: ((totalSemana.numero as double) / 50),
                        max: 50,
                      ),
                    ),
                  );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'No existen datos que coincidan con la acción seleccionada.',
                      style: TextStyle(color: colorBlanco),
                    ),
                  ),
                ),
              );
            }
            listaTotalSemana.clear();
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.check),
        ),
        const SizedBox(width: 15),
        IconButton(
          color: Colors.red,
          highlightColor: const Color.fromARGB(45, 255, 17, 0),
          hoverColor: const Color.fromARGB(30, 255, 17, 0),
          splashColor: const Color.fromARGB(60, 255, 17, 0),
          splashRadius: 25,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.xmark),
        ),
      ],
    );
  }

  Widget botonAcciones() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return CustomListViewAddIndicador(acciones: acciones);
              },
            );
          },
          child: const Text('Elegir Accion')),
    );
  }
}