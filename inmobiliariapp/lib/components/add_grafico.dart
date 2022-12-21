import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/components/tarjeta_indicador.dart';
import 'package:inmobiliariapp/providers/indicadores_provider.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

import 'indicador.dart';

class AddGrafico extends StatefulWidget {
  const AddGrafico({Key? key}) : super(key: key);

  @override
  State<AddGrafico> createState() => _AddGraficoState();
}

String? texto;
String? simboloResultado;
double? size = 22;

// Controllers
final TextEditingController textoController = TextEditingController();

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

class _AddGraficoState extends State<AddGrafico> {
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
              const SizedBox(height: 50),
              resultadoField(),
              const SizedBox(height: 35),
              textoField(),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    color: Colors.green,
                    highlightColor: const Color.fromARGB(45, 76, 175, 80),
                    hoverColor: const Color.fromARGB(30, 76, 175, 80),
                    splashColor: const Color.fromARGB(60, 76, 175, 80),
                    splashRadius: 25,
                    onPressed: () {
                      if (simboloResultado != null &&
                          textoController.text.isNotEmpty) {
                        context.read<IndicadoresProvider>().addItem(
                              TarjetaIndicador(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                resultado: '500$simboloResultado',
                                titulo: textoController.text,
                                indicador: Indicador(
                                  initialValue: 50,
                                  max: 100,
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
                                'No puedes crear un indicador sin titulo ni formato.',
                                style: TextStyle(color: colorBlanco),
                              ),
                            ),
                          ),
                        );
                      }
                      texto = null;
                      textoController.clear();
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
                      texto = null;
                      textoController.clear();
                      Navigator.pop(context);
                    },
                    icon: const Icon(FontAwesomeIcons.xmark),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget textoField() {
    return TextFormField(
      controller: textoController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.length < 2) {
          return 'Escribe un título correcto.';
        }
        return null;
      },
      onSaved: (value) {
        textoController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        label: const Text('Título'),
        contentPadding: const EdgeInsets.all(5),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.text_fields),
        ),
        hintText: 'Captaciones',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget resultadoField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 50,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          border: Border.all(width: 1.65, color: colorGris),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Material(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(Icons.text_format),
                  ),
                  Text(texto ?? 'Formato resultado')
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return content();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget content() {
    return AlertDialog(
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        content: Builder(
          builder: (context) {
            return SizedBox(
              height: 480,
              width: 530,
              child: Material(
                color: Theme.of(context).backgroundColor,
                child: ListView.builder(
                  itemCount: formato.length,
                  itemBuilder: (context, i) {
                    return ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      title: Text(formato[i].tipo),
                      children: [
                        SizedBox(
                          height: formato[i].listaFormatos.length * 48.5,
                          child: Material(
                            color: Theme.of(context).backgroundColor,
                            child: ListView.builder(
                              itemCount: formato[i].listaFormatos.length,
                              itemBuilder: (context, j) {
                                return ListTile(
                                  leading: formato[i].listaFormatos[j].icono,
                                  title: Text(formato[i].listaFormatos[j].tipo),
                                  onTap: () {
                                    setState(() {
                                      texto = formato[i].listaFormatos[j].tipo;
                                      simboloResultado =
                                          formato[i].listaFormatos[j].output;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}

class Cabecera {
  final String tipo;
  final List listaFormatos;

  Cabecera(this.tipo, this.listaFormatos);
}

class Contenido {
  Icon icono;
  String tipo;
  String output;

  Contenido(this.tipo, this.icono, this.output);
}
