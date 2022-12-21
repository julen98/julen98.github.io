import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class SpeedDialFab extends StatefulWidget {
  final Function() notify;
  const SpeedDialFab({Key? key, required this.notify}) : super(key: key);

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  bool toggleFab = true;
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 275),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Alignment alignment1 = const Alignment(0, 0);
  Alignment alignment2 = const Alignment(0, 0);
  Alignment alignment3 = const Alignment(0, 0);
  Alignment alignment4 = const Alignment(0, 0);
  double sizeMiniButtons = 40;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: alignment1,
            duration: toggleFab
                ? const Duration(milliseconds: 275)
                : const Duration(milliseconds: 875),
            curve: toggleFab ? Curves.easeIn : Curves.elasticOut,
            child: GestureDetector(
              child: AnimatedContainer(
                duration: toggleFab
                    ? const Duration(milliseconds: 275)
                    : const Duration(milliseconds: 875),
                curve: toggleFab ? Curves.easeIn : Curves.elasticOut,
                height: sizeMiniButtons,
                width: sizeMiniButtons,
                child: ClipOval(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Material(
                    child: Ink(
                      child: InkWell(
                        onTap: () {
                          widget.notify();
                          toggleFab = !toggleFab;
                          controller.reverse();
                          alignment1 = const Alignment(0, 0);
                          alignment2 = const Alignment(0, 0);
                          alignment3 = const Alignment(0, 0);
                          alignment4 = const Alignment(0, 0);
                        },
                        child: Center(
                          child: Text('1',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                fontFamily: 'Verdana',
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            alignment: alignment2,
            duration: toggleFab
                ? const Duration(milliseconds: 275)
                : const Duration(milliseconds: 875),
            curve: toggleFab ? Curves.easeIn : Curves.elasticOut,
            child: AnimatedContainer(
              duration: toggleFab
                  ? const Duration(milliseconds: 275)
                  : const Duration(milliseconds: 875),
              curve: toggleFab ? Curves.easeIn : Curves.elasticOut,
              height: sizeMiniButtons,
              width: sizeMiniButtons,
              child: ClipOval(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Material(
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        widget.notify();
                        toggleFab = !toggleFab;
                        controller.reverse();
                        alignment1 = const Alignment(0, 0);
                        alignment2 = const Alignment(0, 0);
                        alignment3 = const Alignment(0, 0);
                        alignment4 = const Alignment(0, 0);
                      },
                      child: Center(
                        child: Text('2',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              fontFamily: 'Verdana',
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            alignment: alignment3,
            duration: toggleFab
                ? const Duration(milliseconds: 275)
                : const Duration(milliseconds: 875),
            curve: toggleFab ? Curves.easeIn : Curves.elasticOut,
            child: AnimatedContainer(
              duration: toggleFab
                  ? const Duration(milliseconds: 275)
                  : const Duration(milliseconds: 875),
              curve: toggleFab ? Curves.easeIn : Curves.elasticOut,
              height: sizeMiniButtons,
              width: sizeMiniButtons,
              child: ClipOval(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Material(
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        widget.notify();
                        toggleFab = !toggleFab;
                        controller.reverse();
                        alignment1 = const Alignment(0, 0);
                        alignment2 = const Alignment(0, 0);
                        alignment3 = const Alignment(0, 0);
                        alignment4 = const Alignment(0, 0);
                      },
                      child: Center(
                        child: Text('3',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              fontFamily: 'Verdana',
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            alignment: alignment4,
            duration: toggleFab
                ? const Duration(milliseconds: 275)
                : const Duration(milliseconds: 875),
            curve: toggleFab ? Curves.easeIn : Curves.elasticOut,
            child: AnimatedContainer(
              duration: toggleFab
                  ? const Duration(milliseconds: 275)
                  : const Duration(milliseconds: 875),
              curve: toggleFab ? Curves.easeIn : Curves.elasticOut,
              height: sizeMiniButtons,
              width: sizeMiniButtons,
              child: ClipOval(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Material(
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        widget.notify();
                        toggleFab = !toggleFab;
                        controller.reverse();
                        alignment1 = const Alignment(0, 0);
                        alignment2 = const Alignment(0, 0);
                        alignment3 = const Alignment(0, 0);
                        alignment4 = const Alignment(0, 0);
                      },
                      child: Center(
                        child: Text('4',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              fontFamily: 'Verdana',
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: animation.value * pi * (3 / 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 375),
                curve: Curves.easeOut,
                height: toggleFab ? 60 : 50,
                width: toggleFab ? 60 : 50,
                decoration: BoxDecoration(
                  color: colorAzul,
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    splashColor: const Color.fromARGB(100, 255, 255, 255),
                    hoverColor: const Color.fromARGB(100, 255, 255, 255),
                    onPressed: () {
                      setState(() {
                        if (toggleFab) {
                          toggleFab = !toggleFab;
                          controller.forward();
                          Future.delayed(const Duration(milliseconds: 10), () {
                            alignment1 = const Alignment(-1.2, 0.0);
                          });
                          Future.delayed(const Duration(milliseconds: 10), () {
                            alignment2 = const Alignment(-0.6, 0.0);
                          });
                          Future.delayed(const Duration(milliseconds: 10), () {
                            alignment3 = const Alignment(0.6, 0.0);
                          });
                          Future.delayed(const Duration(milliseconds: 10), () {
                            alignment4 = const Alignment(1.2, 0.0);
                          });
                        } else {
                          toggleFab = !toggleFab;
                          controller.reverse();
                          alignment1 = const Alignment(0, 0);
                          alignment2 = const Alignment(0, 0);
                          alignment3 = const Alignment(0, 0);
                          alignment4 = const Alignment(0, 0);
                        }
                      });
                    },
                    icon: Icon(FontAwesomeIcons.plus,
                        size: 30, color: colorNegro),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
