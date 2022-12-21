import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/model/grupo.dart';
import 'package:inmobiliariapp/providers/conversiones_provider.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

class CustomListViewConversiones extends StatefulWidget {
  const CustomListViewConversiones({Key? key}) : super(key: key);

  @override
  State<CustomListViewConversiones> createState() =>
      _CustomListViewConversionesState();
}

class _CustomListViewConversionesState
    extends State<CustomListViewConversiones> {
  List<String> conversiones = ["Llamada a cita cerrada", "Llamada a exclusiva cerrada", "Llamada a nota de encargo cerrada"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return conversiones.isEmpty
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
                itemCount: conversiones.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(conversiones[i],
                        style: Theme.of(context).textTheme.subtitle2),
                    contentPadding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    onTap: () {
                      context.read<ConversionesProvider>().setConversion(conversiones[i]);
                      debugPrint(context.read<ConversionesProvider>().conversion.toString());
                      Navigator.pop(context);
                    },
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
}
