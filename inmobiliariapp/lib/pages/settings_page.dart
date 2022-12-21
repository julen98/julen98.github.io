import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/components/side_menu.dart';
import 'package:inmobiliariapp/model/user_model.dart';
import 'package:inmobiliariapp/services/auth_service.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:inmobiliariapp/utils/user_simple_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String url = '';
  UserModel user = UserModel('', '', '', '', '');
  GlobalKey<ScaffoldState> settingsKey = GlobalKey<ScaffoldState>();

  Future<void> getUsers() async {
    user = await Database().getUserModel();
    await getUrl();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  bool tema = false;

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).textTheme.bodyText1!.color;
    return Scaffold(
      key: settingsKey,
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                splashRadius: 25,
                icon: Icon(Icons.keyboard_arrow_left, color: color),
                onPressed: () {
                  getUsers();
                  if (user.rol.toLowerCase() == 'agente') {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.popAndPushNamed(context, 'semaforo');
                    });
                  } else if (user.rol.toLowerCase() == 'gerente') {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.popAndPushNamed(context, 'dashboard_gerente');
                    });
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.popAndPushNamed(context, 'login');
                    });
                  }
                },
              ),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    filaSuperior(),
                    const SizedBox(height: 25),
                    buildImagen(),
                    const SizedBox(height: 25),
                    mostrarAjustes(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filaSuperior() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 15),
      child: Text(
        'Ajustes',
        style: Responsive.isDesktop(context)
            ? Theme.of(context).textTheme.headline2
            : Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget mostrarAjustes() {
    return Flexible(
      child: ListView(
        padding: const EdgeInsets.only(right: 10),
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              title: const Text('Cambiar contraseña'),
              shape: shape(),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      insetPadding: EdgeInsets.zero,
                      contentPadding: const EdgeInsets.all(25),
                      content: Builder(
                        builder: (context) {
                          return cambiarPassDialogContent(context);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              title: const Text('Cambiar correo electrónico'),
              onTap: () {},
              shape: shape(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              title: const Text('Cambiar datos del perfil'),
              onTap: () {},
              shape: shape(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              title: const Text('Cambiar tema'),
              onTap: () {
                tema = false;
                UserSimplePreferences.setTema(tema);
                currentTheme.toggleTheme();
              },
              shape: shape(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              title: const Text('Cerrar sesión'),
              onTap: () {
                AuthService(FirebaseAuth.instance).signOut();
                Navigator.popAndPushNamed(context, 'login');
              },
              shape: shape(),
            ),
          ),
        ],
      ),
    );
  }

  Widget cambiarPassDialogContent(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: colorBlanco,
        border: Border.all(
          color: Theme.of(context).backgroundColor == colorNegro
              ? colorGrisOscuro
              : colorGrisMasClaro,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  shape() {
    return RoundedRectangleBorder(
      side: BorderSide(
          color: Theme.of(context).backgroundColor == colorNegro
              ? colorGrisOscuro
              : colorGrisMasClaro,
          width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
  }

  Future<void> getUrl() async {
    url = await obtenerUrl(user.foto);
    if (mounted) setState(() {});
  }

  Widget buildImagen() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
      child: Container(
        height: 225,
        width: 225,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).backgroundColor == colorNegro
                ? colorGrisOscuro
                : colorGrisMasClaro,
          ),
          borderRadius: BorderRadius.circular(9999),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: url == 'vacio'
              ? Icon(
                  Icons.person,
                  color: Theme.of(context).backgroundColor == colorNegro
                      ? colorGris
                      : colorGrisMasClaro,
                  size: 200,
                )
              : url.isEmpty
                  ? SpinKitRing(color: colorAzul, lineWidth: 2, size: 20)
                  : CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.scaleDown,
                      errorWidget: (c, s, d) {
                        return Icon(
                          Icons.person,
                          color: Theme.of(context).backgroundColor == colorNegro
                              ? colorGris
                              : colorGrisMasClaro,
                          size: 200,
                        );
                      },
                    ),
        ),
      ),
    );
  }

  Future<String> obtenerUrl(String path) async {
    if (path.isEmpty) return 'vacio';
    return FirebaseStorage.instance
        .refFromURL('gs://imnovacion.appspot.com/')
        .child(path)
        .getDownloadURL();
  }
}
