import 'package:inmobiliariapp/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences prefs;

  static const _keyNombre = 'nombre';
  static const _keyEmail = 'email';
  static const _keyRol = 'rol';
  static const _keyFoto = 'foto';
  static const _keyTema = 'tema';

  static Future init() async => prefs = await SharedPreferences.getInstance();

  static Future setNombre(String nombre) async =>
      await prefs.setString(_keyNombre, nombre);

  static Future setEmail(String email) async =>
      await prefs.setString(_keyEmail, email);

  static Future setRol(String rol) async => await prefs.setString(_keyRol, rol);

  static Future setFoto(String foto) async =>
      await prefs.setString(_keyFoto, foto);

  static Future setTema(bool tema) async => await prefs.setBool(_keyTema, tema);

  static Future setPreferences(UserModel user) async {
    await prefs.setString(_keyNombre, user.nombre);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyRol, user.rol);
    await prefs.setString(_keyFoto, user.foto);
  }

  static String get nombre => prefs.getString(_keyNombre) ?? '';
  static String get email => prefs.getString(_keyEmail) ?? '';
  static String get rol => prefs.getString(_keyRol) ?? '';
  static String get foto => prefs.getString(_keyFoto) ?? '';
  static bool? get tema => prefs.getBool(_keyTema);
}
