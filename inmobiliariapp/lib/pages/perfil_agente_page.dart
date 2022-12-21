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
import 'package:inmobiliariapp/model/perfil_agente.dart';
import 'package:inmobiliariapp/model/red.dart';
import 'package:inmobiliariapp/model/user_model.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class PerfilAgentePage extends StatefulWidget {
  const PerfilAgentePage({Key? key}) : super(key: key);

  @override
  State<PerfilAgentePage> createState() => _PerfilAgentePageState();
}

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
final TextEditingController birthdateController = TextEditingController();
final TextEditingController genderController = TextEditingController();
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

class _PerfilAgentePageState extends State<PerfilAgentePage> {
  // Archivo imagen (movil)
  File? image;

  // Imagen (web)
  Image? webImage;

  // Tarea a subir a Firestore (imagen)
  late UploadTask uploadTask;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UserModel currentUser = UserModel('', '', '', 'vacio', '');

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
      getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 21, 9, 2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: colorGris, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      tituloPerfil(),
                      avatar(),
                      phoneField(),
                      birthdateField(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (var red in _redes) redesSociales(red),
                        ],
                      ),
                      botonContinuar(),
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
        focusNode: _focusNodes[3],
        keyboardType: TextInputType.number,
        validator: (value) {
          if (!RegExp('^(?:[+34])?[0-9]{9}\$').hasMatch(value!)) {
            return 'El número de teléfono no es válido.';
          } else {
            return null;
          }
        },
        onChanged: (value) => {
          setState(() {}),
        },
        onSaved: (value) {},
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          counterText: "${phoneController.text.length.toString()}/9",
          label: Text(
            'Teléfono',
            style: TextStyle(
              color: _focusNodes[3].hasFocus ? colorAzul : colorBlanco,
            ),
          ),
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: _focusNodes[3].hasFocus ? colorAzul : colorGris,
          ),
        ),
      ),
    );
  }

  Widget birthdateField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: birthdateController,
        focusNode: _focusNodes[4],
        keyboardType: TextInputType.datetime,
        validator: (value) {
          RegExp regExp =
              RegExp(r'^(3[01]|[12][0-9]|0[1-9])/(1[0-2]|0[1-9])/[0-9]{4}$');
          if (!regExp.hasMatch(value!)) {
            return 'La fecha debe tener el formato DD/MM/AAAA (01/01/1900)';
          }
          return null;
        },
        onChanged: (value) => {
          setState(() {}),
        },
        onSaved: (value) {},
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: colorAzul,
              width: 2,
            ),
          ),
          label: Text(
            'Fecha de nacimiento',
            style: TextStyle(
              color: _focusNodes[4].hasFocus ? colorAzul : colorBlanco,
            ),
          ),
          prefixIcon: Icon(
            Icons.calendar_month_outlined,
            color: _focusNodes[4].hasFocus ? colorAzul : colorGris,
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

  enviarPerfilFirestore() async {
    // Llamando a firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // Llamando al profile model
    PerfilAgente profileModel = PerfilAgente(
      fechaDeNacimiento: birthdateController.text,
      genero: '',
      telefono: phoneController.text,
    );

    // Escribiendo los valores
    profileModel.facebook = facebookController.text;
    profileModel.linkedin = linkedinController.text;
    profileModel.instagram = instagramController.text;

    // Mandando valores
    await firebaseFirestore
        .collection('users')
        .doc(currentUser.email)
        .update(profileModel.toMap());

    Fluttertoast.showToast(msg: 'Perfil creado correctamente.').then(
      (value) => Future.delayed(
        const Duration(seconds: 1),
        () => Navigator.popAndPushNamed(context, 'semaforo'),
      ),
    );
  }

  Widget botonContinuar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text('Continuar'), Icon(Icons.arrow_right)],
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: () {
          enviarPerfilFirestore();
        },
      ),
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
}
