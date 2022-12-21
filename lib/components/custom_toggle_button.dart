import 'package:flutter/material.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class CustomToggleButton extends StatefulWidget {
  const CustomToggleButton({Key? key}) : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

bool isPressed = false;

class _CustomToggleButtonState extends State<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: double.infinity,
          height: 49,
          decoration: BoxDecoration(
            color: isPressed ? colorAzul : Theme.of(context).backgroundColor,
            border: isPressed ? null : Border.all(color: colorGris, width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Material(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.circular(15),
            color: Colors.transparent,
            child: Ink(
              child: InkWell(
                onTap: () => setState(() => isPressed = !isPressed),
                child: Center(
                  child: Text(
                    isPressed
                        ? 'Comparado con objetivo'
                        : 'Comparado con la agencia',
                    style: TextStyle(
                      color: isPressed
                          ? colorNegro
                          : Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
