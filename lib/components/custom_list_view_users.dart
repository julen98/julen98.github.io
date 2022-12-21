import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/model/user_model.dart';
import 'package:inmobiliariapp/providers/indicadores_provider.dart';
import 'package:inmobiliariapp/utils/database.dart';
import 'package:inmobiliariapp/utils/responsive.dart';
import 'package:inmobiliariapp/utils/size_config.dart';
import 'package:inmobiliariapp/utils/theme.dart';
import 'package:provider/provider.dart';

class CustomListViewUsers extends StatefulWidget {
  const CustomListViewUsers({Key? key}) : super(key: key);

  @override
  State<CustomListViewUsers> createState() => _CustomListViewUsersState();
}

class _CustomListViewUsersState extends State<CustomListViewUsers> {
  List<bool> arePressed = [];
  List<UserModel> users = [];
  List<String> urls = [];

  void generateEmptyLists() {
    for (var i = 0; i < users.length; i++) {
      arePressed.add(false);
      urls.add('');
    }
  }

  Future<void> getUsers() async {
    users = await Database().getAgentes();
    generateEmptyLists();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      content: users.isEmpty
          ? SpinKitRing(color: colorAzul, lineWidth: 4)
          : Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    botonSalir(),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 1000
                          : SizeConfig.width * 0.9,
                      height: 800,
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(15),
                        child: Material(
                          color: Theme.of(context).backgroundColor,
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1.5,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? colorGrisOscuro
                                          : colorGrisClaro,
                                    ),
                                  ),
                                ),
                                child: Ink(
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<IndicadoresProvider>()
                                          .setUser(users[i]);
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        buildImagen(users, urls, i),
                                        Text(
                                          users[i].nombre,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> getUrl(List<UserModel> users, List<String> urls, int i) async {
    urls[i] = await obtenerUrl(users[i].foto);
    if (mounted) setState(() {});
  }

  Widget buildImagen(List<UserModel> users, List<String> urls, int i) {
    getUrl(users, urls, i);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          border: Border.all(color: colorGris),
          borderRadius: BorderRadius.circular(9999),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: urls[i] == 'vacio'
              ? Icon(
                  FontAwesomeIcons.xmark,
                  color: Theme.of(context).backgroundColor == colorNegro
                      ? colorGris
                      : colorGrisMasClaro,
                )
              : urls[i].isEmpty
                  ? SpinKitRing(color: colorAzul, lineWidth: 2, size: 20)
                  : CachedNetworkImage(
                      imageUrl: urls[i],
                      fit: BoxFit.scaleDown,
                    ),
        ),
      ),
    );
  }

  Future<String> obtenerUrl(String path) async {
    if (path.isEmpty) {
      return 'vacio';
    }
    return FirebaseStorage.instance
        .refFromURL('gs://imnovacion.appspot.com/')
        .child(path)
        .getDownloadURL();
  }

  Widget botonSalir() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 1),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 20,
          icon: const Icon(FontAwesomeIcons.xmark, size: 20),
        ),
      ),
    );
  }
}
