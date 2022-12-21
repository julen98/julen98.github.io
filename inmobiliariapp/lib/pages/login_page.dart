import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inmobiliariapp/model/user_model.dart';
import 'package:inmobiliariapp/services/auth_service.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:inmobiliariapp/utils/user_simple_preferences.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Bools para el boton de login para mostrar la carga
bool isAnimating = true;
ButtonState state = ButtonState.init;

enum ButtonState { init, loading, done }

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passController = TextEditingController();

  String? errorMessage;

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    _focusNodes[0].addListener(() => setState(() {}));
    _focusNodes[1].addListener(() => setState(() {}));
    isLogged();
    super.initState();
  }

  @override
  void dispose() {
    _focusNodes[0].dispose();
    _focusNodes[1].dispose();
    super.dispose();
  }

//=======================================================================================

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // Anchura boton login
    bool isDone = state == ButtonState.done;
    bool isStretched = isAnimating || state == ButtonState.init;
    state = ButtonState.init;

    return Scaffold(
      body: Center(
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
                    const SizedBox(height: 50),
                    SizedBox(
                      child: Theme.of(context).textTheme.bodyText1!.color ==
                              colorBlanco
                          ? Image.asset("assets/images/branding_dark.png", 
                              fit: BoxFit.contain, height: 200)
                          : Image.asset("assets/images/branding_light.png",
                              fit: BoxFit.contain, height: 200),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 15, 15, 15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            emailField(),
                            const SizedBox(height: 10),
                            passwordField(),
                            const SizedBox(height: 10),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                              width: state == ButtonState.init
                                  ? SizeConfig.width
                                  : 70,
                              onEnd: () =>
                                  setState(() => isAnimating = !isAnimating),
                              height: 50,
                              child: isStretched
                                  ? buildSignInButton()
                                  : buildSmallButton(isDone),
                            ),
                            const SizedBox(height: 15),
                            registerButton(),
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

  Future<void> isLogged() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        return;
      }
      postDetailsToFirestore();
    });
  }

  Widget emailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: _focusNodes[0],
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Debes introducir tu email.';
        }
        if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
          return 'Por favor, introduce un email correcto.';
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hoverColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(5),
        prefixIcon: Icon(Icons.mail_outlined,
            color: _focusNodes[0].hasFocus ? colorAzul : colorGris),
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget passwordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: _focusNodes[1],
      controller: passController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ('Debes introducir tu contraseña.');
        }
        if (!regex.hasMatch(value)) {
          return ('Por favor, introduce una contraseña válida. (Mínimo de 6 caracteres)');
        }
        return null;
      },
      onSaved: (value) {
        passController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hoverColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(5),
        prefixIcon: Icon(Icons.lock_outlined,
            color: _focusNodes[1].hasFocus ? colorAzul : colorGris),
        hintText: 'Contraseña',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    final _email = emailController.text;
    final _pass = passController.text;
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 5,
          colors: [
            colorRosa,
            colorAzul,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        child: FittedBox(
          child: Text('Iniciar sesión',
              style: TextStyle(color: colorNegro, fontWeight: FontWeight.w500)),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(colorAzul),
          minimumSize: MaterialStateProperty.all(const Size(300, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          // elevation: MaterialStateProperty.all(3),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: () async {
          setState(() => state = ButtonState.loading);
          bool loggedIn = await context
              .read<AuthService>()
              .signIn(email: _email, pass: _pass);
          if (loggedIn) {
            postDetailsToFirestore();
          } else {
            if (mounted) {
              setState(() => state = ButtonState.init);
            }
          }
        },
      ),
    );
  }

  postDetailsToFirestore() async {
    var userModel = await Database().getUserModel();

    if (mounted) {
      setState(() => state = ButtonState.done);
    }
    debugPrint(userModel.toString());
    await UserSimplePreferences.setPreferences(userModel);
    debugPrint('Relogeando...');
    Navigator.popAndPushNamed(
      context,
      userModel.rol.toLowerCase() == 'gerente'
          ? 'dashboard_gerente'
          : 'semaforo',
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

  Widget registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('¿No tienes una cuenta? '),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'register');
          },
          child: const Text(
            'Regístrate',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
