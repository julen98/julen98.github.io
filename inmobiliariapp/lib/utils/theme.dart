import 'package:flutter/material.dart';
import 'package:inmobiliariapp/utils/user_simple_preferences.dart';

CustomTheme currentTheme = CustomTheme();

// Colores
Color colorRosa = const Color.fromARGB(255, 255, 62, 255);
Color masClaro = const Color.fromARGB(255, 140, 228, 255);
Color claro = const Color.fromARGB(255, 103, 214, 255);
Color mediano = const Color.fromARGB(255, 0, 143, 199);
Color masOscuro = const Color.fromARGB(255, 0, 95, 139);
Color colorAzul = const Color.fromARGB(255, 0, 196, 255);
Color colorBlanco = const Color.fromARGB(255, 255, 255, 255);
Color colorNegro = Color.fromARGB(255, 34, 34, 34);
Color colorGrisMasOscuro = const Color.fromARGB(255, 22, 22, 22);
Color colorGrisOscuro = const Color.fromARGB(255, 42, 42, 42);
Color colorGris = const Color.fromARGB(255, 92, 92, 92);
Color colorGrisMasClaro = const Color.fromARGB(255, 222, 222, 222);
Color colorGrisClaro = const Color.fromARGB(255, 132, 132, 132);

class CustomTheme with ChangeNotifier {
  bool _isDarkTheme = UserSimplePreferences.tema ?? true;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = UserSimplePreferences.tema ?? true;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      primaryColor: colorAzul,
      backgroundColor: colorBlanco,
      scaffoldBackgroundColor: colorBlanco,
      dialogBackgroundColor: colorBlanco,
      hoverColor: colorGris.withOpacity(0.3),
      hintColor: colorGris,
      focusColor: colorAzul,
      splashColor: colorAzul,
      fontFamily: 'Poppins',
      cardTheme: CardTheme(
        color: colorBlanco,
        shadowColor: const Color.fromARGB(255, 220, 216, 217),
        elevation: 10,
      ),
      iconTheme: IconThemeData(
        color: colorNegro,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(colorGris),
          elevation: MaterialStateProperty.all(3),
          overlayColor: MaterialStateProperty.all(colorGris),
          foregroundColor: MaterialStateProperty.all(colorNegro),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(colorAzul),
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontFamily: 'Poppins', fontSize: 16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.fromLTRB(75, 15, 75, 15)),
          shadowColor: MaterialStateProperty.all(colorGris),
          elevation: MaterialStateProperty.all(3),
          overlayColor: MaterialStateProperty.all(colorAzul),
          foregroundColor: MaterialStateProperty.all(colorNegro),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(colorNegro),
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontFamily: 'Poppins', fontSize: 16)),
        ),
      ),
      appBarTheme: AppBarTheme(
        color: colorAzul,
        elevation: 0,
        titleTextStyle:
            TextStyle(color: colorNegro, fontFamily: 'Poppins', fontSize: 18),
        iconTheme: IconThemeData(
          color: colorNegro,
        ),
      ),
      primaryIconTheme: IconThemeData(
        color: colorNegro,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colorNegro,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorBlanco,
        elevation: 5,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          color: colorNegro,
          fontFamily: 'Poppins',
          fontSize: 50,
          fontWeight: FontWeight.w800,
        ),
        headline2: TextStyle(
          color: colorNegro,
          fontFamily: 'Poppins',
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
        headline3: TextStyle(
          color: colorNegro,
          fontFamily: 'Poppins',
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        headline4: TextStyle(
          color: colorNegro,
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        headline5:
            TextStyle(color: colorNegro, fontFamily: 'Poppins', fontSize: 16),
        headline6:
            TextStyle(color: colorNegro, fontFamily: 'Poppins', fontSize: 16),
        bodyText1: TextStyle(
          color: colorNegro,
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyText2:
            TextStyle(color: colorNegro, fontFamily: 'Poppins', fontSize: 16),
        subtitle1:
            TextStyle(color: colorNegro, fontFamily: 'Poppins', fontSize: 16),
        subtitle2: TextStyle(
          color: colorGrisMasOscuro,
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        caption:
            TextStyle(color: colorNegro, fontFamily: 'Poppins', fontSize: 16),
        button:
            TextStyle(color: colorNegro, fontFamily: 'Poppins', fontSize: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(5),
        labelStyle: TextStyle(
          color: colorNegro,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorGris,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorGris,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorAzul,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        iconColor: colorNegro,
        prefixIconColor: colorNegro,
        suffixIconColor: colorNegro,
      ),
      colorScheme: ColorScheme(
        primary: colorAzul,
        secondary: colorAzul,
        background: colorBlanco,
        brightness: Brightness.light,
        error: Colors.red,
        surface: colorBlanco,
        onBackground: colorBlanco,
        onError: colorBlanco,
        onPrimary: colorBlanco,
        onSecondary: colorBlanco,
        onSurface: colorBlanco,
      ),
      scrollbarTheme: const ScrollbarThemeData().copyWith(
        thumbColor:
            MaterialStateProperty.all(const Color.fromARGB(30, 158, 158, 158)),
      ),
    );
  }

  //============================================ OSCURO ============================================

  ThemeData get darkTheme {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      shadowColor: Colors.white.withOpacity(0.3),
      primaryColor: colorAzul,
      backgroundColor: colorNegro,
      scaffoldBackgroundColor: colorNegro,
      dialogBackgroundColor: colorNegro,
      cardTheme: CardTheme(
        color: colorNegro,
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 10,
      ),
      hoverColor: colorGris.withOpacity(0.3),
      hintColor: colorGris,
      focusColor: colorAzul,
      splashColor: colorAzul,
      fontFamily: 'Poppins',
      iconTheme: IconThemeData(
        color: colorBlanco,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(colorGris),
          elevation: MaterialStateProperty.all(3),
          overlayColor: MaterialStateProperty.all(colorBlanco),
          foregroundColor: MaterialStateProperty.all(colorNegro),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(colorAzul),
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontFamily: 'Poppins', fontSize: 16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(colorAzul),
          foregroundColor: MaterialStateProperty.all(colorBlanco),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontFamily: 'Poppins', fontSize: 16)),
        ),
      ),
      appBarTheme: AppBarTheme(
        color: colorAzul,
        elevation: 0,
        titleTextStyle:
            TextStyle(color: colorNegro, fontFamily: 'Poppins', fontSize: 18),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: colorBlanco,
        ),
      ),
      primaryIconTheme: IconThemeData(
        color: colorBlanco,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colorBlanco,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorNegro,
        elevation: 5,
        scrimColor: colorGris,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          color: colorBlanco,
          fontFamily: 'Poppins',
          fontSize: 50,
          fontWeight: FontWeight.w800,
        ),
        headline2: TextStyle(
          color: colorBlanco,
          fontFamily: 'Poppins',
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
        headline3: TextStyle(
          color: colorBlanco,
          fontFamily: 'Poppins',
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        headline4: TextStyle(
          color: colorBlanco,
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        headline5:
            TextStyle(color: colorBlanco, fontFamily: 'Poppins', fontSize: 16),
        headline6:
            TextStyle(color: colorBlanco, fontFamily: 'Poppins', fontSize: 16),
        bodyText1: TextStyle(
          color: colorBlanco,
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyText2:
            TextStyle(color: colorBlanco, fontFamily: 'Poppins', fontSize: 16),
        subtitle1:
            TextStyle(color: colorBlanco, fontFamily: 'Poppins', fontSize: 16),
        subtitle2: TextStyle(
          color: colorGrisMasClaro,
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        caption:
            TextStyle(color: colorBlanco, fontFamily: 'Poppins', fontSize: 16),
        button:
            TextStyle(color: colorBlanco, fontFamily: 'Poppins', fontSize: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorNegro,
        constraints: const BoxConstraints(minHeight: 45),
        contentPadding: const EdgeInsets.all(5),
        labelStyle: TextStyle(
          color: colorBlanco,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorBlanco,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorGris,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorAzul,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        iconColor: colorBlanco,
        prefixIconColor: colorBlanco,
        suffixIconColor: colorBlanco,
      ),
      colorScheme: ColorScheme(
        primary: colorAzul,
        secondary: colorAzul,
        background: colorNegro,
        brightness: Brightness.dark,
        error: Colors.red,
        surface: colorNegro,
        onBackground: colorNegro,
        onError: Colors.red,
        onPrimary: colorNegro,
        onSecondary: colorBlanco,
        onSurface: colorNegro,
      ),
      scrollbarTheme: const ScrollbarThemeData().copyWith(
        thumbColor:
            MaterialStateProperty.all(const Color.fromARGB(30, 158, 158, 158)),
      ),
    );
  }
}
