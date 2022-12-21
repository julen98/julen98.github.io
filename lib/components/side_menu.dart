import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/providers/sidemenu_provider.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SideMenuProvider>(context);
    final isCollapsed = provider.isCollapsed;
    return Responsive.isDesktop(context)
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: AnimatedContainer(
                width: isCollapsed ? 250 : 65,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: colorGrisOscuro, width: 1.5),
                ),
                duration: const Duration(milliseconds: 200),
                child: drawer(context),
              ),
            ),
          )
        : drawer(context);
  }
}

Widget drawer(BuildContext context) {
  final provider = Provider.of<SideMenuProvider>(context);
  final isCollapsed = provider.isCollapsed;
  return Drawer(
    elevation: 0,
    backgroundColor: Theme.of(context).backgroundColor,
    shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(Responsive.isDesktop(context) ? 50 : 0)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Responsive.isDesktop(context))
          Padding(
            padding: EdgeInsets.only(right: isCollapsed ? 22 : 0),
            child: Align(
              alignment: isCollapsed ? Alignment.topRight : Alignment.center,
              child: IconButton(
                tooltip: isCollapsed ? 'Contraer' : 'Expandir',
                icon: Icon(
                  isCollapsed
                      ? FontAwesomeIcons.anglesLeft
                      : FontAwesomeIcons.anglesRight,
                  size: 15,
                ),
                splashRadius: 25,
                onPressed: () {
                  final provider =
                      Provider.of<SideMenuProvider>(context, listen: false);

                  provider.toggleIsCollapsed();
                },
              ),
            ),
          ),
        const SizedBox(height: 35),
        DrawerListTile(
          title: 'Dashboard',
          icon: FontAwesomeIcons.chartLine,
          onTap: () {
            Navigator.popAndPushNamed(context, 'dashboard_gerente');
          },
        ),
        DrawerListTile(
          title: 'Añadir usuarios',
          icon: FontAwesomeIcons.userPlus,
          onTap: () {
            Navigator.popAndPushNamed(context, 'anadir');
          },
        ),
        DrawerListTile(
          title: 'Calendario',
          icon: FontAwesomeIcons.calendar,
          onTap: () {
            Navigator.popAndPushNamed(context, 'calendario');
          },
        ),
        DrawerListTile(
          title: 'Ajustes',
          icon: FontAwesomeIcons.gear,
          onTap: () => Navigator.pushNamed(context, 'settings'),
        ),
      ],
    ),
  );
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const double? size = 22;

    return ListTile(
      hoverColor: const Color.fromARGB(64, 123, 123, 123),
      onTap: onTap,
      horizontalTitleGap: 8.0,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      leading: Icon(icon, size: size),
      title: Text(title, overflow: TextOverflow.ellipsis),
      style: ListTileStyle.list,
    );
  }
}
