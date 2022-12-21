import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inmobiliariapp/components/side_menu.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class AnadirUsersPage extends StatefulWidget {
  const AnadirUsersPage({Key? key}) : super(key: key);

  @override
  State<AnadirUsersPage> createState() => _AnadirUsersPageState();
}

// Controllers
final TextEditingController eliminarEmailController = TextEditingController();
final TextEditingController anadirEmailController = TextEditingController();

class _AnadirUsersPageState extends State<AnadirUsersPage> {
  // Keys
  GlobalKey<ScaffoldState> myKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myKey,
      drawer: Responsive.isDesktop(context) ? null : const SideMenu(),
      drawerScrimColor: Colors.black.withOpacity(0.6),
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                splashRadius: 25,
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                onPressed: () => myKey.currentState!.openDrawer(),
              ),
            ),
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context)) const SideMenu(),
            Expanded(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (Responsive.isDesktop(context))
                      const SizedBox(height: 55),
                    Text('Añadir Usuarios',
                        style: Theme.of(context).textTheme.headline4),
                    Expanded(child: anadirUsers()),
                    Text('Eliminar Usuarios',
                        style: Theme.of(context).textTheme.headline4),
                    Expanded(child: eliminarUsers()),
                    const SizedBox(height: 55),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget anadirEmail() {
    return Material(
      color: colorAzul,
      child: Ink(
        child: InkWell(
          child: Center(
              child:
                  Text('Añadir correo', style: TextStyle(color: colorNegro))),
          onTap: () {
            enviarEmail();
          },
        ),
      ),
    );
  }

  Widget eliminarEmail() {
    return Material(
      color: colorAzul,
      child: Ink(
        child: InkWell(
          child: Center(
              child:
                  Text('Añadir correo', style: TextStyle(color: colorNegro))),
          onTap: () {
            enviarEmailEliminado();
          },
        ),
      ),
    );
  }

  Widget anadirEmailField() {
    return TextFormField(
      autofocus: false,
      controller: anadirEmailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Debes introducir tu email.';
        }
        if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
          return 'El email introducido es incorrecto.';
        }
        return null;
      },
      onSaved: (value) {
        anadirEmailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.mail, color: Colors.grey),
        ),
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
  
  Widget eliminarEmailField() {
    return TextFormField(
      autofocus: false,
      controller: eliminarEmailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Debes introducir tu email.';
        }
        if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
          return 'El email introducido es incorrecto.';
        }
        return null;
      },
      onSaved: (value) {
        eliminarEmailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.mail, color: Colors.grey),
        ),
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget anadirUsers() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 300,
        maxHeight: 300,
        maxWidth: 500,
      ),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: Theme.of(context).backgroundColor == colorNegro
                ? colorGris
                : colorGrisClaro,
            width: 1.5),
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Theme.of(context).backgroundColor == colorNegro
              ? colorGrisOscuro
              : colorGrisMasClaro,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 50, width: 400, child: anadirEmailField()),
                const SizedBox(height: 35),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: anadirEmail(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget eliminarUsers() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 300,
        maxHeight: 300,
        maxWidth: 500,
      ),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: Theme.of(context).backgroundColor == colorNegro
                ? colorGris
                : colorGrisClaro,
            width: 1.5),
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Theme.of(context).backgroundColor == colorNegro
              ? colorGrisOscuro
              : colorGrisMasClaro,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 50, width: 400, child: eliminarEmailField()),
                const SizedBox(height: 35),
                SizedBox(
                  height: 50,
                  width: 400,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: eliminarEmail(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> enviarEmail() async {
    // Llamando a firestore
    var user = FirebaseAuth.instance.currentUser;
    var uid = user?.email;

    // Mandando valores
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('emails')
        .doc(anadirEmailController.text)
        .set({'email': anadirEmailController.text, 'permitido': true}).then((value) {
      Fluttertoast.showToast(msg: 'Correo añadido correctamente.');
      anadirEmailController.clear();
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: 'Ha ocurrido un error al intentar enviar el email.');
    });
  }

  Future<void> enviarEmailEliminado() async {
    // Llamando a firestore
    var user = FirebaseAuth.instance.currentUser;
    var uid = user?.email;

    // Mandando valores
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('emails')
        .doc(eliminarEmailController.text)
        .set({'email': eliminarEmailController.text, 'permitido': true}).then((value) {
      Fluttertoast.showToast(msg: 'Correo añadido correctamente.');
      eliminarEmailController.clear();
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: 'Ha ocurrido un error al intentar enviar el email.');
    });
  }
}
