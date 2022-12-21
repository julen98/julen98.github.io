import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/components/semaforo.dart';
import 'package:inmobiliariapp/model/dia.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class SemaforoPage extends StatefulWidget {
  const SemaforoPage({Key? key}) : super(key: key);

  @override
  _SemaforoPageState createState() => _SemaforoPageState();
}

// Variables alerta
int diasCumplidos = 5;
late Text textoAlerta;
late Icon iconoAlerta;

List<Accion> lunes = [];
List<Accion> martes = [];
List<Accion> miercoles = [];
List<Accion> jueves = [];
List<Accion> viernes = [];
List<Accion> sabado = [];
List<Accion> domingo = [];

List<Dia> dias = [
  Dia('Lunes'),
  Dia('Martes'),
  Dia('Miércoles'),
  Dia('Jueves'),
  Dia('Viernes'),
  Dia('Sábado'),
  Dia('Domingo')
];

late List<Accion> accionesFirestore;

class _SemaforoPageState extends State<SemaforoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semáforo'),
        leading: IconButton(
          splashRadius: 25,
          tooltip: 'Añadir acciones diarias',
          icon: Icon(Icons.list, color: colorNegro),
          onPressed: () {
            Navigator.popAndPushNamed(context, 'acciones');
          },
        ),
        actions: [
          IconButton(
            splashRadius: 25,
            tooltip: 'Ajustes',
            icon: Icon(Icons.settings, color: colorNegro),
            onPressed: () {
              Navigator.popAndPushNamed(context, 'settings');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Accion>>(
          future: getAccionesUser(),
          builder: (context, data) {
            if (!data.hasData) {
              return SpinKitRing(color: colorAzul, lineWidth: 4);
            }
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/FONDO.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Semaforo(
                              diasCumplidos: diasCumplidos, semaforo: 'verde'),
                          const SizedBox(height: 24),
                          Semaforo(
                              diasCumplidos: diasCumplidos,
                              semaforo: 'amarillo'),
                          const SizedBox(height: 24),
                          Semaforo(
                              diasCumplidos: diasCumplidos, semaforo: 'rojo'),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: double.infinity,
                      width: 125,
                      child: Column(
                        children: [
                          // Bucle para crear la tabla de los dias
                          for (var dia in dias) buildDias(dia),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  // Widget para construir los expanded de los dias
  Widget buildDias(Dia dia) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 50, minWidth: 125),
        decoration: BoxDecoration(border: Border.all(color: colorGris)),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
              splashColor: const Color.fromARGB(19, 255, 255, 255),
              hoverColor: const Color.fromARGB(19, 255, 255, 255),
              highlightColor: const Color.fromARGB(19, 255, 255, 255),
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dia.dia,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  dia.cumplido
                      ? const Icon(FontAwesomeIcons.check, color: Colors.green)
                      : const Icon(FontAwesomeIcons.xmark, color: Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget condicionAlerta() {
    double? size = 150;
    diasCumplidos = 5;
    if (diasCumplidos >= 0 && diasCumplidos < 2) {
      textoAlerta = const Text('No ha cumplido el objetivo de esta semana.');
      iconoAlerta = Icon(Icons.emoji_emotions, size: size, color: Colors.red);
      return buildAlerta(textoAlerta, iconoAlerta);
    } else if (diasCumplidos >= 2 && diasCumplidos < 4) {
      textoAlerta = const Text('Ha llegado al objetivo mínimo de esta semana.');
      iconoAlerta =
          Icon(Icons.emoji_emotions, size: size, color: Colors.yellow);
      return buildAlerta(textoAlerta, iconoAlerta);
    } else if (diasCumplidos >= 4) {
      textoAlerta =
          const Text('Ha cumplido el objetivo de esta semana, ¡enhorabuena!');
      iconoAlerta = Icon(Icons.emoji_emotions, size: size, color: Colors.green);
      return buildAlerta(textoAlerta, iconoAlerta);
    } else {
      return buildAlerta(
        const Text('Ha ocurrido un error inesperado.\n'
            'Si el error persiste, póngase en contacto con soporte.'),
        Icon(Icons.error_rounded, size: size, color: Colors.red),
      );
    }
  }

  Future<void> mostrarAlerta(BuildContext context) async {
    showDialog(context: context, builder: (context) => condicionAlerta());
  }

  Widget buildAlerta(icono, texto) {
    return AlertDialog(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      title: texto,
      content: icono,
      actions: [
        IconButton(
          splashRadius: 25,
          tooltip: 'Cerrar',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.xmark),
        ),
      ],
    );
  }

  void obtenerSemana(acciones) {
    for (var accion in acciones) {
      switch (accion.fecha.weekday) {
        case 1:
          lunes.add(accion);
          break;
        case 2:
          martes.add(accion);
          break;
        case 3:
          miercoles.add(accion);
          break;
        case 4:
          jueves.add(accion);
          break;
        case 5:
          viernes.add(accion);
          break;
        case 0:
          domingo.add(accion);
          break;
        default:
          Fluttertoast.showToast(
              msg: 'Ha ocurrido un error inesperado con los días semanales.\n'
                  'Por favor, póngase en contacto con soporte.');
      }
    }
  }

  Future<List<Accion>> getAccionesUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .collection('acciones')
        .get();

    accionesFirestore = query.docs.map((doc) => Accion.fromDoc(doc)).toList();

    obtenerSemana(accionesFirestore);
    return accionesFirestore;
  }
}
