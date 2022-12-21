// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/model/perfil_gerente.dart';
import 'package:inmobiliariapp/model/red.dart';
import 'package:inmobiliariapp/model/user_model.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class PerfilGerentePage extends StatefulWidget {
  const PerfilGerentePage({Key? key}) : super(key: key);

  @override
  State<PerfilGerentePage> createState() => _PerfilGerentePageState();
}

// Bool para el boton de login para mostrar la carga
bool isLoading = false;
bool isAnimating = true;
ButtonState state = ButtonState.init;

enum ButtonState { init, loading, done }

// FocusNodes para los textfields, para cambiar el formato al darle click al texfield
final List<FocusNode> _focusNodes = [
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
];

// Bools para los toggles e iconos
List<bool> isSelected = [true, false];
bool facebookIsPressed = false;
bool instagramIsPressed = false;
bool linkedinIsPressed = false;

// Controllers
final TextEditingController phoneController = TextEditingController();
final TextEditingController numeroEmpleadosController = TextEditingController();
final TextEditingController direccionController = TextEditingController();
final TextEditingController linkedinController = TextEditingController();
final TextEditingController facebookController = TextEditingController();
final TextEditingController instagramController = TextEditingController();

final List<Red> _redes = [
  Red('Facebook', FontAwesomeIcons.facebookSquare, facebookController,
      facebookIsPressed),
  Red('Instagram', FontAwesomeIcons.instagramSquare, instagramController,
      instagramIsPressed),
  Red('Linkedin', FontAwesomeIcons.linkedin, linkedinController,
      linkedinIsPressed),
];

// Form key
GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _PerfilGerentePageState extends State<PerfilGerentePage> {
  // Archivo imagen (movil)
  File? image;

  // Imagen (web)
  Image? webImage;

  UserModel currentUser = UserModel('', '', '', '', '');

  Future<void> getUser() async {
    currentUser = await Database().getUserModel();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    // Anchura boton continuar
    final width = MediaQuery.of(context).size.width;
    bool isDone = state == ButtonState.done;
    bool isStretched = isAnimating || state == ButtonState.init;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.topCenter,
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    children: [
                      tituloPerfil(),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 21, 9, 2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: colorGris, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              avatar(),
                              const SizedBox(height: 30),
                              phoneField(),
                              const SizedBox(height: 10),
                              numeroEmpleadosField(),
                              const SizedBox(height: 10),
                              direccionField(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var red in _redes) redesSociales(red),
                                ],
                              ),
                              const SizedBox(height: 20),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                                width: state == ButtonState.init ? width : 70,
                                onEnd: () =>
                                    setState(() => isAnimating = !isAnimating),
                                height: 50,
                                child: isStretched
                                    ? botonContinuar()
                                    : buildSmallButton(isDone),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tituloPerfil() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
      child: Text('Configurar perfil',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3),
    );
  }

  Widget avatar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: currentUser.foto == 'vacio'
                ? imagenDefault()
                : buildImagen(context),
          ),
        ],
      ),
    );
  }

  Widget phoneField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: phoneController,
        focusNode: _focusNodes[0],
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) return 'Debe poner un número de teléfono';
          if (RegExp('^(?:[+34])?[0-9]{9}\$').hasMatch(value)) return null;
          return 'El número de teléfono no es válido.';
        },
        textInputAction: TextInputAction.next,
        onSaved: (value) {
          phoneController.text = value!;
        },
        decoration: InputDecoration(
          filled: true,
          hoverColor: Colors.transparent,
          counterText: "${phoneController.text.length.toString()}/9",
          label: Text(
            'Teléfono',
            style: TextStyle(
              color: _focusNodes[0].hasFocus ? colorAzul : colorBlanco,
            ),
          ),
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: _focusNodes[0].hasFocus ? colorAzul : colorGris,
          ),
        ),
      ),
    );
  }

  Widget numeroEmpleadosField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: numeroEmpleadosController,
        focusNode: _focusNodes[1],
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) return 'Debe poner el número de empleados';
          if (RegExp('^[0-9]*\$').hasMatch(value)) return null;
          return 'Solo puede introducir números.';
        },
        textInputAction: TextInputAction.next,
        onSaved: (value) {
          numeroEmpleadosController.text = value!;
        },
        decoration: InputDecoration(
          filled: true,
          hoverColor: Colors.transparent,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: colorAzul,
              width: 2,
            ),
          ),
          label: Text(
            'Número de empleados',
            style: TextStyle(
              color: _focusNodes[1].hasFocus ? colorAzul : colorBlanco,
            ),
          ),
          prefixIcon: Icon(
            Icons.numbers_outlined,
            color: _focusNodes[1].hasFocus ? colorAzul : colorGris,
          ),
        ),
      ),
    );
  }

  Widget direccionField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: direccionController,
        focusNode: _focusNodes[2],
        keyboardType: TextInputType.streetAddress,
        validator: (value) {
          if (value!.isNotEmpty) return null;
          return 'Debe introducir una dirección.';
        },
        textInputAction: TextInputAction.next,
        onSaved: (value) {
          direccionController.text = value!;
        },
        decoration: InputDecoration(
          filled: true,
          hoverColor: Colors.transparent,
          label: Text(
            'Dirección',
            style: TextStyle(
              color: _focusNodes[2].hasFocus ? colorAzul : colorBlanco,
            ),
          ),
          prefixIcon: Icon(
            Icons.near_me_outlined,
            color: _focusNodes[2].hasFocus ? colorAzul : colorGris,
          ),
        ),
      ),
    );
  }

  Widget redesSociales(Red red) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
      child: GestureDetector(
        key: UniqueKey(),
        onTap: () {
          setState(() {
            red.isPressed = true;
          });
          showDialog(
            context: context,
            builder: (context) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: Responsive.isDesktop(context) ? 400 : 100,
                  maxHeight: Responsive.isDesktop(context) ? 400 : 100,
                  minWidth: Responsive.isDesktop(context) ? 400 : 100,
                  minHeight: Responsive.isDesktop(context) ? 400 : 100,
                ),
                child: AlertDialog(
                  title: Text('Introduce tu ${red.red}'),
                  content: TextFormField(
                    controller: red.controller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Debe introducir su usuario.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.link),
                      label: Text(red.red),
                      hintText: 'Pedro-Martinez-Martinez',
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('CANCELAR',
                          style: Theme.of(context).textTheme.bodyText1),
                      onPressed: () {
                        setState(() {
                          red.isPressed = false;
                        });
                        red.controller.clear();
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('OK',
                          style: Theme.of(context).textTheme.bodyText1),
                      onPressed: () {
                        setState(() {
                          if (red.controller.text.isEmpty) {
                            red.isPressed = false;
                          } else {
                            red.isPressed = true;
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(red.icono,
            size: 50, color: red.isPressed ? colorAzul : colorGris),
      ),
    );
  }

  Widget botonContinuar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton(
        child: const FittedBox(
          child: Text('Continuar'),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          setState(() => state = ButtonState.loading);
          enviarPerfilFirestore();
        },
      ),
    );
  }

  Widget buildSmallButton(bool isDone) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorAzul,
      ),
      child: isDone
          ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.done, size: 40, color: colorNegro),
            )
          : Center(
              child: SpinKitRing(size: 40, color: colorNegro, lineWidth: 4)),
    );
  }

  // Genero imagen por defecto (es un icono)
  Widget imagenDefault() {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Material(
              color: colorGris,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Icon(Icons.person,
                    size: Responsive.isDesktop(context) ? 190 : 140,
                    color: Theme.of(context).backgroundColor),
              ),
            ),
          ),
          iconoAnadirImagen(),
        ],
      ),
    );
  }

  // FAB para desplegar popup
  Widget iconoAnadirImagen() {
    return Positioned(
      right: Responsive.isDesktop(context) ? 14 : 10,
      bottom: Responsive.isDesktop(context) ? 14 : 10,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onSecondary,
              width: 2,
            ),
            color: masOscuro,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () async {
              subirImagenFirestore();
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.add_a_photo,
                size: 25,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Construyo la imagen obtenida
  Widget buildImagen(BuildContext context) {
    return StreamBuilder<String>(
      stream: obtenerUrl(currentUser.foto).asStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return SizedBox(
              height: Responsive.isDesktop(context) ? 250 : 210,
              width: Responsive.isDesktop(context) ? 250 : 210,
              child: SpinKitRing(color: colorAzul, lineWidth: 4));
        }
        return Stack(
          children: [
            CircleAvatar(
              radius: Responsive.isDesktop(context) ? 126.5 : 106.5,
              backgroundColor: Theme.of(context).hoverColor,
              child: CircleAvatar(
                radius: Responsive.isDesktop(context) ? 125 : 105,
                backgroundColor: Theme.of(context).backgroundColor,
                child: GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(999),
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data!,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              SpinKitRing(color: colorAzul, lineWidth: 4),
                      errorWidget: (context, url, downloadProgress) =>
                          SpinKitRing(color: colorAzul, lineWidth: 4),
                      fit: BoxFit.cover,
                      width: Responsive.isDesktop(context) ? 250 : 210,
                      height: Responsive.isDesktop(context) ? 250 : 210,
                    ),
                  ),
                ),
              ),
            ),
            iconoAnadirImagen(),
          ],
        );
      },
    );
  }

  elegirImagen({required Function(html.File file) onSelected}) {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'fotos_agencias/*';
    uploadInput.click();

    uploadInput.onChange.listen(
      (event) {
        html.File? file = uploadInput.files!.first;
        html.FileReader reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen(
          (event) {
            onSelected(file);
          },
        );
      },
    );
  }

  Future<String> obtenerUrl(final path) async {
    return FirebaseStorage.instance
        .refFromURL('gs://imnovacion.appspot.com/')
        .child(path)
        .getDownloadURL();
  }

  void cargarImagen(final path) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({'foto': path})
        .then((value) => setState(() {}))
        .catchError((e) => {Fluttertoast.showToast(msg: e!.message)});
  }

  void subirImagenFirestore() async {
    String name = FirebaseAuth.instance.currentUser!.uid.toString();
    final filePath = 'fotos_agencias/$name.png';
    elegirImagen(
      onSelected: (file) {
        if (file.size <= 1000000) {
          FirebaseStorage.instance
              .refFromURL('gs://imnovacion.appspot.com/')
              .child(filePath)
              .putBlob(file)
              .then((value) => cargarImagen(filePath))
              .catchError((e) => Fluttertoast.showToast(
                  msg:
                      'Ha sucedido un error inesperado. Por favor, contacta con el soporte.'));
        } else {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: 'El archivo es demasiado grande (lím. de 1 MB).');
        }
      },
    );
  }

  enviarPerfilFirestore() async {
    // Llamando a firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // Escribiendo los valores
    PerfilGerente gerente = PerfilGerente(telefono: phoneController.text);
    gerente.facebook = facebookController.text;
    gerente.linkedin = linkedinController.text;
    gerente.instagram = instagramController.text;

    if (formKey.currentState!.validate()) {
      await firebaseFirestore
          .collection('users')
          .doc(currentUser.email)
          .update(gerente.toMap())
          .catchError((e) => {Fluttertoast.showToast(msg: e!.message)})
          .then((value) => {
                setState(() => state = ButtonState.done),
                Fluttertoast.showToast(msg: 'Perfil creado correctamente.')
                    .then(
                  (value) => Future.delayed(
                    const Duration(seconds: 1),
                    () =>
                        Navigator.popAndPushNamed(context, 'dashboard_gerente'),
                  ),
                ),
              });
    }
    if (mounted) {
      setState(() => state = ButtonState.init);
    }
  }
}
