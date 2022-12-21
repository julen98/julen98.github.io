import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/components/custom_list_view_acciones.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class AccionesPage extends StatefulWidget {
  const AccionesPage({Key? key}) : super(key: key);

  @override
  AccionesPageState createState() => AccionesPageState();
}

Database db = Database();
List<Accion> acciones = [];
List<Accion> accionesDiarias = [];
List<Accion> accionesJson = [];

class AccionesPageState extends State<AccionesPage> {
  Future<void> getGrupos() async {
    acciones = await db.getAcciones();
    await db.getAccionesUser();
    setState(() {});
  }

  @override
  void initState() {
    getGrupos();
    super.initState();
    debugPrint(db.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Enviar acciones',
        elevation: 0,
        onPressed: () async {
          for (var i = 0; i < acciones.length; i++) {
            if (acciones[i].numero > 0) {
              accionesDiarias.add(acciones[i]);
            }
          }

          for (Accion accion in accionesDiarias) {
            db.addAcciones(accion);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Las acciones han sido enviadas correctamente.',
                  style: TextStyle(color: colorBlanco),
                ),
              ),
            ),
          );

          setState(() {});
        },
        child: Icon(FontAwesomeIcons.paperPlane, color: colorNegro),
      ),
      appBar: AppBar(
        title: const Text('Acciones'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'semaforo');
          },
          icon: Icon(Icons.arrow_left, color: colorNegro),
        ),
        centerTitle: true,
      ),
      body: acciones.isEmpty
          ? SpinKitRing(color: colorAzul, lineWidth: 4)
          : Align(
            alignment: Alignment.topCenter,
            child: CustomListViewAcciones(acciones: acciones),
          ),
    );
  }
}
