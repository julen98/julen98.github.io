import 'package:flutter/material.dart';
import 'package:inmobiliariapp/model/accion.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class CustomButton extends StatefulWidget {
  final Accion accion;
  final String texto;
  final BorderRadiusGeometry? borderRadius;
  final void Function() onTap;

  const CustomButton({
    Key? key,
    required this.accion,
    required this.texto,
    required this.onTap,
    required this.borderRadius,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool detectarRango() {
    if (widget.texto == 'A') {
      return widget.accion.yearPressed;
    } else if (widget.texto == 'M') {
      return widget.accion.mesPressed;
    } else {
      return widget.accion.semanaPressed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: detectarRango() ? colorAzul : colorNegro,
        border: Border.all(color: colorAzul, width: 1.5),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          child: InkWell(
            hoverColor: detectarRango()
                ? colorBlanco.withOpacity(.05)
                : colorBlanco.withOpacity(.05),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                widget.texto,
                style: TextStyle(
                  color: detectarRango() ? colorNegro : colorAzul,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
