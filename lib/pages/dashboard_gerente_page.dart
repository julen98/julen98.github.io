import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/components/add_indicador.dart';
import 'package:inmobiliariapp/components/custom_list_view_users.dart';
import 'package:inmobiliariapp/components/indicador.dart';
import 'package:inmobiliariapp/components/side_menu.dart';
import 'package:inmobiliariapp/components/tarjeta_indicador.dart';
import 'package:inmobiliariapp/model/user_model.dart';
import 'package:inmobiliariapp/providers/indicadores_provider.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:provider/provider.dart';

class DashboardGerentePage extends StatelessWidget {
  GlobalKey<ScaffoldState> dashboardGerenteKey = GlobalKey<ScaffoldState>();
  DashboardGerentePage({Key? key}) : super(key: key);

  UserModel userModel = UserModel('', '', '', 'vacio', '');

  Future<void> getUser() async {
    userModel = await Database().getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    SizeConfig().init(context);
    Color? colorTexto = Theme.of(context).textTheme.bodyText1!.color;
    if (userModel.rol == 'Agente') {
      Navigator.popAndPushNamed(context, 'login');
    }
    return Scaffold(
      key: dashboardGerenteKey,
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                splashRadius: 25,
                icon: Icon(Icons.menu, color: colorTexto),
                onPressed: () => dashboardGerenteKey.currentState!.openDrawer(),
              ),
            ),
      drawer: Responsive.isDesktop(context) ? null : const SideMenu(),
      drawerScrimColor: Colors.black.withOpacity(0.6),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorTexto,
        onPressed: () {
          if (context.read<IndicadoresProvider>().user.email.isEmpty) {
            Fluttertoast.showToast(
                msg: 'Debe elegir un agente antes de añadir indicadores.');
            return;
          }
          showDialog(
            builder: (BuildContext context) {
              return const AddIndicador();
            },
            context: context,
          );
        },
        child: Icon(
          FontAwesomeIcons.plus,
          color: Theme.of(context).backgroundColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context)) const SideMenu(),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 55),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      filaSuperior(context),
                      SizedBox(height: SizeConfig.paddingVertical * 4),
                      mostrarIndicadores(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filaSuperior(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '¡Bienvenido/a!',
          style: Responsive.isDesktop(context)
              ? Theme.of(context).textTheme.headline2
              : Theme.of(context).textTheme.headline3,
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const CustomListViewUsers(),
            );
          },
          child: const Text('Elegir agente'),
        ),
      ],
    );
  }

  SizedBox mostrarIndicadores(BuildContext context) {
    return SizedBox(
      width: SizeConfig.width,
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.start,
        children: [
          for (var indicador in context.watch<IndicadoresProvider>().list)
            indicador,
        ],
      ),
    );
  }
}