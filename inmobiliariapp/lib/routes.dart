import 'package:flutter/cupertino.dart';

import 'pages/acciones_page.dart';
import 'pages/anadir_users_page.dart';
import 'pages/calendario_page.dart';
import 'pages/dashboard_gerente_page.dart';
import 'pages/login_page.dart';
import 'pages/perfil_agente_page.dart';
import 'pages/perfil_gerente_page.dart';
import 'pages/register_page.dart';
import 'pages/semaforo_page.dart';
import 'pages/settings_page.dart';

Map<String, Widget Function(BuildContext)> getApplicationRoutes() {
  return <String, Widget Function(BuildContext)>{
    '/': (context) => const LoginPage(),
    'register': (context) => const RegisterPage(),
    'perfil_agente': (context) => const PerfilAgentePage(),
    'perfil_gerente': (context) => const PerfilGerentePage(),
    'semaforo': (context) => const SemaforoPage(),
    'dashboard_gerente': (context) => DashboardGerentePage(),
    'acciones': (context) => const AccionesPage(),
    'anadir': (context) => const AnadirUsersPage(),
    'settings': (context) => const SettingsPage(),
    'calendario': (context) => const CalendarioPage(),
  };
}
