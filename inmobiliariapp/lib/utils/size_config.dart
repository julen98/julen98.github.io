import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double width;
  static late double height;
  static late double paddingHorizontal;
  static late double paddingVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;
    paddingHorizontal = (width / 100);
    paddingVertical = (height / 100);
  }
}
