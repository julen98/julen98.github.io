import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inmobiliariapp/model/agencia.dart';
import 'package:inmobiliariapp/model/user_model.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/theme.dart';

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild!.context == null);
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // FocusNodes para los textfields, para cambiar el formato al darle click al texfield
  final List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  // Bools para los toggles
  List<bool> isSelected = [true, false];

  // Bool para saber si la agencia existe
  bool existe = false;

  // Instancia de autenticacion en Firebase
  final _auth = FirebaseAuth.instance;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final agenciaController = TextEditingController();

  // String mensaje de error
  String? errorMessage;

  @override
  void initState() {
    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Theme.of(context).textTheme.bodyText1!.color ==
                              Colors.white
                          ? Image.asset('assets/images/branding_dark.png',
                              fit: BoxFit.contain, height: 200)
                          : Image.asset('assets/images/branding_light.png',
                              fit: BoxFit.contain, height: 200),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 21, 9, 2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: colorGris, width: 1.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            agenciaField(),
                            const SizedBox(height: 15),
                            nameField(),
                            const SizedBox(height: 15),
                            emailField(),
                            const SizedBox(height: 15),
                            passwordField(),
                            const SizedBox(height: 15),
                            confirmPasswordField(),
                            const SizedBox(height: 15),
                            agenteGerenteButtons(),
                            const SizedBox(height: 25),
                            signUpButton(),
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
    );
  }

  Widget agenciaField() {
    return TextFormField(
      autofocus: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNodes[0],
      controller: agenciaController,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) => context.nextEditableTextFocus(),
      style: TextStyle(
          fontWeight:
              focusNodes[0].hasFocus ? FontWeight.w500 : FontWeight.normal),
      validator: (value) {
        RegExp regExp = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ('Debe introducir su agencia.');
        }
        if (!regExp.hasMatch(value)) {
          return ('Por favor, introduzca un nombre válido. (Mínimo de 2 caracteres)');
        }
        return null;
      },
      onSaved: (value) {
        agenciaController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        label: Text(
          'Agencia',
          style: TextStyle(
              color: focusNodes[0].hasFocus ? colorAzul : colorBlanco),
        ),
        prefixIcon: Icon(Icons.apartment_outlined,
            color: focusNodes[0].hasFocus ? colorAzul : colorGris),
        hintText: 'Nombre de la agencia',
        suffixIcon: IconButton(
          onPressed: () {
            agenciaController.clear();
            if (mounted) setState(() {});
          },
          icon: Icon(Icons.clear,
              color: agenciaController.text.isNotEmpty
                  ? colorGris
                  : Colors.transparent),
        ),
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      autofocus: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNodes[1],
      controller: nameController,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) => context.nextEditableTextFocus(),
      style: TextStyle(
          fontWeight:
              focusNodes[1].hasFocus ? FontWeight.w500 : FontWeight.normal),
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ('Debe introducir su nombre.');
        }
        if (!regex.hasMatch(value)) {
          return ('Por favor, introduzca un nombre válido. (Mínimo de 2 caracteres)');
        }
        return null;
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        label: Text(
          'Nombre',
          style: TextStyle(
              color: focusNodes[1].hasFocus ? colorAzul : colorBlanco),
        ),
        prefixIcon: Icon(Icons.person_outline,
            color: focusNodes[1].hasFocus ? colorAzul : colorGris),
        hintText: 'Nombre completo',
        suffixIcon: IconButton(
          onPressed: () {
            nameController.clear();
            if (mounted) setState(() {});
          },
          icon: Icon(Icons.clear,
              color: nameController.text.isNotEmpty
                  ? colorGris
                  : Colors.transparent),
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      autofocus: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController,
      focusNode: focusNodes[2],
      keyboardType: TextInputType.emailAddress,
      onFieldSubmitted: (_) => context.nextEditableTextFocus(),
      style: TextStyle(
          fontWeight:
              focusNodes[2].hasFocus ? FontWeight.w500 : FontWeight.normal),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Debe introducir su email.';
        }
        if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
          return 'El email introducido es incorrecto.';
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        label: Text(
          'Email',
          style: TextStyle(
              color: focusNodes[2].hasFocus ? colorAzul : colorBlanco),
        ),
        prefixIcon: Icon(Icons.mail_outline,
            color: focusNodes[2].hasFocus ? colorAzul : colorGris),
        hintText: 'su@correo.es',
        suffixIcon: IconButton(
          onPressed: () {
            emailController.clear();
            if (mounted) setState(() {});
          },
          icon: Icon(Icons.clear,
              color: emailController.text.isNotEmpty
                  ? colorGris
                  : Colors.transparent),
        ),
      ),
    );
  }

  Widget passwordField() {
    return TextFormField(
      autofocus: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNodes[3],
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ('Debe introducir su contraseña.');
        }
        if (!regex.hasMatch(value)) {
          return ('Por favor, introduzca una contraseña válida. (Mínimo de 6 caracteres)');
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => context.nextEditableTextFocus(),
      decoration: InputDecoration(
        filled: true,
        label: Text(
          'Contraseña',
          style: TextStyle(
              color: focusNodes[3].hasFocus ? colorAzul : colorBlanco),
        ),
        prefixIcon: Icon(Icons.lock_outlined,
            color: focusNodes[3].hasFocus ? colorAzul : colorGris),
        hintText: 'Min. 6 caracteres',
        suffixIcon: IconButton(
          onPressed: () {
            passwordController.clear();
            if (mounted) setState(() {});
          },
          icon: Icon(Icons.clear,
              color: passwordController.text.isNotEmpty
                  ? colorGris
                  : Colors.transparent),
        ),
      ),
    );
  }

  Widget confirmPasswordField() {
    return TextFormField(
      autofocus: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNodes[4],
      controller: confirmPasswordController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ('Debe introducir su contraseña.');
        }
        if (value != passwordController.text) {
          return ('Las contraseñas no coinciden.');
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        label: Text(
          'Confirmar contraseña',
          style: TextStyle(
              color: focusNodes[4].hasFocus ? colorAzul : colorBlanco),
        ),
        prefixIcon: Icon(Icons.lock_outlined,
            color: focusNodes[4].hasFocus ? colorAzul : colorGris),
        hintText: 'Repita la contraseña',
        suffixIcon: IconButton(
          onPressed: () {
            confirmPasswordController.clear();
            if (mounted) setState(() {});
          },
          icon: Icon(Icons.clear,
              color: confirmPasswordController.text.isNotEmpty
                  ? colorGris
                  : Colors.transparent),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return ElevatedButton(
      child: const Text('Registrarte'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: () {
        postDetailsAndSignUp();
      },
    );
  }

  Widget agenteGerenteButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              border: Border.all(color: colorAzul, width: 1.5),
              color: isSelected[0]
                  ? colorAzul
                  : Theme.of(context).backgroundColor,
            ),
            child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    isSelected[0] = true;
                    isSelected[1] = false;
                    if (mounted) setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Agente',
                        style: TextStyle(
                          color: isSelected[0]
                              ? colorNegro
                              : Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              border: Border.all(color: colorAzul, width: 1.5),
              color: isSelected[1]
                  ? colorAzul
                  : Theme.of(context).backgroundColor,
            ),
            child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    isSelected[1] = true;
                    isSelected[0] = false;
                    if (mounted) setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Gerente',
                        style: TextStyle(
                          color: isSelected[1]
                              ? colorNegro
                              : Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void signUp(String email, String password) async {
    if (formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'ERROR_EMAIL_ALREADY_IN_USE':
          case 'account-exists-with-different-credential':
          case 'email-already-in-use':
            errorMessage =
                'El email introducido ya existe. Vuelve a la página de login.';
            break;
          case 'ERROR_INVALID_EMAIL':
          case 'invalid-email':
            errorMessage = 'El email no está bien formado.';
            break;
          case 'ERROR_WRONG_PASSWORD':
          case 'wrong-password':
            errorMessage = 'La contraseña es incorrecta.';
            break;
          case 'ERROR_USER_NOT_FOUND':
          case 'user-not-found':
            errorMessage = 'No existe ningún usuario con este email.';
            break;
          case 'ERROR_USER_DISABLED':
          case 'user-disabled':
            errorMessage = 'El usuario con este email ha sido bloqueado.';
            break;
          case 'ERROR_TOO_MANY_REQUESTS':
          case 'too-many-requests':
            errorMessage = 'Has hecho demasiados intentos.';
            break;
          case 'ERROR_OPERATION_NOT_ALLOWED':
          case 'operation-not-allowed':
            errorMessage = 'Registrarse no está habilitado.';
            break;
          default:
            errorMessage = 'Algo inesperado ha ocurrido.';
        }
        Fluttertoast.showToast(msg: errorMessage!);
      }
    }
  }

  postDetailsAndSignUp() async {
    // Llamando a firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // Creando el usuario
    var userModel = UserModel(
      emailController.text,
      nameController.text,
      isSelected[0] ? 'Agente' : 'Gerente',
      'vacio',
      agenciaController.text,
    );

    if (isSelected[1]) {
      var agencias = await Database().getAgencias();
      for (var agencia in agencias) {
        if (agencia.nombre == agenciaController.text) {
          existe = true;
        } else {
          existe = false;
        }
      }
      if (existe) {
        Fluttertoast.showToast(
            msg:
                'La agencia ya existe, no puedes registrarte como gerente de nuevo.');
        return;
      } else {
        signUp(emailController.text, passwordController.text);

        // Se crea la agencia en la base de datos
        await FirebaseFirestore.instance
            .collection('agencias')
            .doc(agenciaController.text)
            .set({'nombre': agenciaController.text});

        // Mandando valores del usuario
        await firebaseFirestore
            .collection('users')
            .doc(emailController.text)
            .set(userModel.toMap());
        Fluttertoast.showToast(msg: 'Cuenta creada correctamente.').then(
          (value) => Navigator.popAndPushNamed(
            context,
            isSelected[0] ? 'perfil_agente' : 'perfil_gerente',
          ),
        );
      }
    } else {
      signUp(emailController.text, passwordController.text);

      // Mandando valores del usuario
      await firebaseFirestore
          .collection('users')
          .doc(emailController.text)
          .set(userModel.toMap());

      Fluttertoast.showToast(msg: 'Cuenta creada correctamente.').then(
        (value) => Navigator.popAndPushNamed(
          context,
          isSelected[0] ? 'perfil_agente' : 'perfil_gerente',
        ),
      );
    }
  }
}
