import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:inmobiliariapp/providers/indicadores_provider.dart';
import 'package:inmobiliariapp/providers/sidemenu_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'pages/login_page.dart';
import 'providers/conversiones_provider.dart';
import 'providers/objetivos_provider.dart';
import 'routes.dart';
import 'services/auth_service.dart';
import 'utils/custom_scroll_behavior.dart';
import 'utils/theme.dart';
import 'utils/user_simple_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await UserSimplePreferences.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ObjetivosProvider()),
        ChangeNotifierProvider(create: (_) => ConversionesProvider()),
        ChangeNotifierProvider(create: (_) => IndicadoresProvider()),
        ChangeNotifierProvider(create: (_) => SideMenuProvider()),
        ChangeNotifierProvider(
            create: (context) => AuthService(FirebaseAuth.instance)),
      ],
      builder: (context, snapshot) {
        return MaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [Locale('es')],
          theme: currentTheme.lightTheme,
          darkTheme: currentTheme.darkTheme,
          themeMode: currentTheme.currentTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: getApplicationRoutes(),
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext builder) => const LoginPage());
          },
        );
      },
    );
  }
}
